import ComposableArchitecture
import Core

public struct VoteItemCore: Reducer {
  public struct State: Equatable, Identifiable {
    var vote: Vote
    
    public var id: Int { return vote.id }
    
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
  }
  
  @Dependency(\.network) var networkManager

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .report:
        return .none
        
      case .commentList:
        return .none
        
      case .profileTapped:
        // TODO: Move To Profile
        return .none
        
      case .bookmarkTapped:
        state.vote.isBookmarked.toggle()
        return .run { send in
          // TODO: Request BookMark API
          // TODO: Success ToastMessage
          // TODO: UpdateUI
        } catch: { error, send in
          // TODO: Error ToastMessage
        }
        
      case .commentTapped:
        state.commentListState = .init(voteID: state.vote.id)
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
