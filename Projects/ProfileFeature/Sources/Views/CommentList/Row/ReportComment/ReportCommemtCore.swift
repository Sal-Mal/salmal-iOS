import UI
import Core
import ComposableArchitecture

public struct ReportCommentCore: Reducer {
  public struct State: Equatable {
    let comment: Comment
    
    var isMyComment: Bool {
      return comment.memberId == UserDefaultsService.shared.memberID
    }
    
    var items: [MenuItem] {
      if isMyComment {
        return [
          .init(icon: .init(icon: .ic_pencil), title: "수정"),
          .init(icon: .init(icon: .ic_trash), title: "삭제"),
        ]
      } else {
        return [.init(icon: .init(icon: .ic_warning), title: "신고")]
      }
    }
  }
  
  public enum Action: Equatable {
    case edit
    case delete
    case report
    case response(TaskResult<String>)
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case refreshList
      case editComment(Comment)
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.commentRepository) var commentRepo
  @Dependency(\.toastManager) var toastManager
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .edit:
        return .run { [state] send in

          await send(.delegate(.editComment(state.comment)))
          await dismiss()
        }
        
      case .delete:
        return .run { [id = state.comment.id] send in
          await send(.response(TaskResult {
            try await commentRepo.delete(commentID: id)
            return "삭제"
          }))
        }
      case .report:
        return .run { [id = state.comment.id] send in
          await send(.response(TaskResult {
            try await commentRepo.report(commentID: id)
            return "신고"
          }))
        }
        
      case let .response(.success(message)):
        return .run { send in
          await toastManager.showToast(.success("댓글 \(message) 완료했어요"))
          await dismiss()
          await send(.delegate(.refreshList))
        }
        
      case let .response(.failure(error)):
        print(error.localizedDescription)
        // TODO: Show Toast Message
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
