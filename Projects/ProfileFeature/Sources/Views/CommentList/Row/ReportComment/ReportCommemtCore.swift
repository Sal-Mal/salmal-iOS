import UI
import Core
import ComposableArchitecture

public struct ReportCommentCore: Reducer {
  public struct State: Equatable {
    let memberID: Int
    let commentID: Int
    
    var isMyComment: Bool {
      return memberID == UserDefaultsService.shared.memberID
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
      case editComment
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.commentRepository) var commentRepo
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .edit:
        return .run { send in
          await send(.delegate(.editComment))
          await dismiss()
        }
        
      case .delete:
        return .run { [id = state.commentID] send in
          await send(.response(TaskResult {
            try await commentRepo.delete(commentID: id)
            return "삭제"
          }))
        }
      case .report:
        return .run { [id = state.commentID] send in
          await send(.response(TaskResult {
            try await commentRepo.report(commentID: id)
            return "신고"
          }))
        }
        
      case let .response(.success(message)):
        // TODO: Show Toast Message
        return .run { send in
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
