import ComposableArchitecture
import Core
import Foundation

public struct CommentListCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
    let commentCount: Int
    var comments: IdentifiedArrayOf<CommentCore.State> = []
    @BindingState var text: String = ""
    
    var editingCommentID: Int?
    var profileImageURL: String?
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case comment(id: CommentCore.State.ID, action: CommentCore.Action)
    case requestComments
    case commentsResponse(TaskResult<[Comment]>)
    case requestMyPage
    case myPageResponse(Member)
    case tapConfirmButton
    case reset
  }
  
  @Dependency(\.commentRepository) var commentRepo
  @Dependency(\.memberRepository) var memberRepo
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .comment(id, .delegate(.editComment)):
        guard let comment = state.comments[id: id]?.comment else {
          return .none
        }
        
        state.text = comment.content
        state.editingCommentID = comment.id
        
        return .none
        
      case .comment(_, .delegate(.refreshList)):
        return .send(.requestComments)
        
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
        // TODO: 댓글 리스트 요청 실패 (Toast Message)
        print(error.localizedDescription)
        return .none
        
      case .requestMyPage:
        return .run { send in
          let result = try await memberRepo.myPage()
          await send(.myPageResponse(result))
        } catch: { error, send in
          // TODO: 마이페이지 이미지 url 다운로드 실패
          print(error.localizedDescription)
        }
        
      case let .myPageResponse(member):
        state.profileImageURL = member.imageURL
        return .none
        
      case .tapConfirmButton:
        return .run { [state] send in
          
          let text = state.text
          let voteID = state.voteID
          
          // editing
          if let commentID = state.editingCommentID {
            try await commentRepo.edit(commentID: commentID, text: text)
          }
          // writing
          else {
            try await commentRepo.write(voteID: voteID, text: text)
          }

          await send(.requestComments)
          await send(.reset)
        } catch: { error, send in
          // TODO: 댓글 입력 업로드 실패 (Toast Message)
          print(error)
        }
        
      case .reset:
        state.editingCommentID = nil
        state.text = ""
        return .none
      }
    }
    .forEach(\.comments, action: /Action.comment(id:action:)) {
      CommentCore()
    }
  }
}
