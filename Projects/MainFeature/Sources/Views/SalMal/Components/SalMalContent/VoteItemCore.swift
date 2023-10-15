import ComposableArchitecture
import Core

public struct VoteItemCore: Reducer {
  public struct State: Equatable, Identifiable {
    var vote: Vote
    let originalVote: Vote
    
    public var id: Int { return vote.id }
    
    init(vote: Vote) {
      self.vote = vote
      self.originalVote = vote
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
    case setBookmark(Bool)
    case onAppear
    case onDisappear
  }
  
  @Dependency(\.network) var networkManager
  
  enum CancelID {
    case bookmark
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        if state.vote != state.originalVote {
          // TODO: 유저가 조작해서 뭔가 다르다면, 투표 api 재요청
        }

        return .none
        
      case .onDisappear:
        return .none
        
      case .report:
        return .none
        
      case .commentList:
        return .none
        
      case .profileTapped:
        // TODO: Move To Profile
        return .none
        
      case .bookmarkTapped:
        return .run { [state] send in
          let api = state.vote.isBookmarked
          ? VoteAPI.unBookmark(id: state.vote.id)
          : VoteAPI.bookmark(id: state.vote.id)
          
          try await networkManager.request(api)
          await send(.setBookmark(!state.vote.isBookmarked))
        } catch: { error, send in
          // TODO: ToastMessage 띄우기
          debugPrint(error.localizedDescription)
        }
        .cancellable(id: CancelID.bookmark, cancelInFlight: true)
      
      case let .setBookmark(value):
        state.vote.isBookmarked = value
        return .none
        
      case .commentTapped:
        state.commentListState = .init(voteID: state.vote.id, commentCount: state.vote.commentCnt)
        return .none
        
      case .moreTapped:
        state.reportState = .init(voteID: state.vote.id, memberID: state.vote.memberID)
        return .none
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
