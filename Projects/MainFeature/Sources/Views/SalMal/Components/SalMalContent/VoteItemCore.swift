
import ProfileFeature
import ComposableArchitecture
import Core

public struct VoteItemCore: Reducer {
  public struct State: Equatable, Identifiable {
    let vote: Vote
    
    public var id: Int { return vote.id }
    
    var isMine: Bool {
      return UserDefaultsService.shared.memberID == vote.memberID
    }
    
    init(vote: Vote) {
      self.vote = vote
    }
    
    @PresentationState var reportState: ReportCore.State?
    @PresentationState var commentListState: CommentListCore.State?
  }
  
  public enum Action: Equatable {
    case report(PresentationAction<ReportCore.Action>)
    case commentList(PresentationAction<CommentListCore.Action>)
    case profileTapped
    case bookmarkTapped
    case commentTapped
    case moreTapped
    case requestVote
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case updateVote(Vote)
      case moveToProfile(id: Int)
    }
  }
  
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.userDefault) var userDefault
  
  enum CancelID {
    case bookmark
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
        
      case .report:
        return .none
        
      case .commentList:
        return .none
        
      case .profileTapped:
        if state.vote.memberID != userDefault.memberID {
          return .send(.delegate(.moveToProfile(id: state.vote.memberID)))
        }
        
        return .none
        
      case .bookmarkTapped:
        return .run { [state] send in
          if state.vote.isBookmarked {
            try await voteRepository.unBookmark(voteID: state.vote.id)
          } else {
            try await voteRepository.bookmark(voteID: state.vote.id)
          }
          
          await send(.requestVote)
          
        } catch: { error, send in
          // TODO: ToastMessage 띄우기
          debugPrint(error.localizedDescription)
        }
        .cancellable(id: CancelID.bookmark, cancelInFlight: true)
        
      case .commentTapped:
        state.commentListState = .init(voteID: state.vote.id, commentCount: state.vote.commentCnt)
        return .none
        
      case .moreTapped:
        state.reportState = .init(voteID: state.vote.id, memberID: state.vote.memberID)
        return .none
        
      case .requestVote:
        return .run { [id = state.vote.id] send in
          let vote = try await voteRepository.getVote(id: id)
          await send(.delegate(.updateVote(vote)))
        }
      }
    }
    .ifLet(\.$commentListState, action: /Action.commentList) {
      CommentListCore()
    }
    .ifLet(\.$reportState, action: /Action.report) {
      ReportCore()
    }
  }
}
