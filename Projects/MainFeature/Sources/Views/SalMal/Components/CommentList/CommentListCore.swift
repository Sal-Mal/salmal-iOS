import ComposableArchitecture
import Core

public struct CommentListCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
    var comments: IdentifiedArrayOf<CommentCore.State> = []
  }
  
  public enum Action: Equatable {
    case comment(id: CommentCore.State.ID, action: CommentCore.Action)
    case requestComments
  }
  
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .requestComments:
        let dummy = CommentListResponse.mock.comments.map(\.toDomain)
        
        let states = dummy.map {
          CommentCore.State(comment: $0)
        }
        
        state.comments.append(contentsOf: states)
        return .none
      default:
        return .none
      }
    }
    .forEach(\.comments, action: /Action.comment(id:action:)) {
      CommentCore()
    }
  }
}
