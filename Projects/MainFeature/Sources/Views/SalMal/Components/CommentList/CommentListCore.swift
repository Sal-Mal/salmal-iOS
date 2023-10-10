import ComposableArchitecture
import Core
import Foundation

public struct CommentListCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
    var comments: IdentifiedArrayOf<CommentCore.State> = []
  }
  
  public enum Action: Equatable {
    case comment(id: CommentCore.State.ID, action: CommentCore.Action)
    case requestComments
    case commentResponse(TaskResult<[Comment]>)
  }
  
  @Dependency(\.commentRepository) var commentRepo
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .requestComments:
        return .run { [id = state.voteID] send in
          await send(.commentResponse(
            TaskResult {
              try await commentRepo.list(id: id)
            }
          ))
        }
        
      case let .commentResponse(.success(entity)):
        let commentStates = entity.map { CommentCore.State(comment: $0) }
        state.comments.append(contentsOf: commentStates)
        return .none
        
      case let .commentResponse(.failure(error)):
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
