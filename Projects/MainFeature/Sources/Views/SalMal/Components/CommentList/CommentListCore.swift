import ComposableArchitecture
import Core
import Foundation

public struct CommentListCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
    var comments: IdentifiedArrayOf<CommentCore.State> = []
    @BindingState var text: String = ""
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case comment(id: CommentCore.State.ID, action: CommentCore.Action)
    case requestComments
    case commentsResponse(TaskResult<[Comment]>)
    case tapConfirmButton
  }
  
  @Dependency(\.commentRepository) var commentRepo
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .comment:
        return .none
        
      case .requestComments:
        return .run { [id = state.voteID] send in
          await send(.commentsResponse(
            TaskResult {
              try await commentRepo.list(id: id)
            }
          ))
        }
        
      case let .commentsResponse(.success(entity)):
        state.comments = []
        let commentStates = entity.map { CommentCore.State(comment: $0) }
        state.comments.append(contentsOf: commentStates)
        return .none
        
      case let .commentsResponse(.failure(error)):
        // TODO: 댓글 리스트 요청 실패
        print(error)
        return .none
        
      case .tapConfirmButton:
        return .run { [id = state.voteID, text = state.text] send in
          try await commentRepo.write(id: id, text: text)
          // TODO: 코맨트 작성하고, 업로드하고, 댓글 다시 당겨오기
          await send(.requestComments)
        } catch: { error, send in
          // TODO: 댓글 입력 업로드 실패
          print(error)
        }
      }
    }
    .forEach(\.comments, action: /Action.comment(id:action:)) {
      CommentCore()
    }
  }
}
