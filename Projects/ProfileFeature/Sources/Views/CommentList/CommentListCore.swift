import ComposableArchitecture
import Core
import Foundation

public enum CommentMode: Equatable {
  case editComment(commentID: Int)
  case writeComment(voteID: Int)
  case writeReply(commentID: Int)
}

public struct CommentListCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
    var comments: IdentifiedArrayOf<CommentCore.State> = []
    @BindingState var text: String = ""
    
    var profileImageURL: String?
    var commentMode: CommentMode?
    
    public init(voteID: Int, commentCount: Int) {
      self.voteID = voteID
      self.commentMode = .writeComment(voteID: voteID)
    }
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
  
  public init() { }
  
  @Dependency(\.commentRepository) var commentRepo
  @Dependency(\.memberRepository) var memberRepo
  @Dependency(\.toastManager) var toastManager
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .comment(_, .delegate(.editComment(comment))):
        state.text = comment.content
        state.commentMode = .editComment(commentID: comment.id)
        NotificationService.post(.tapAddComment)
        return .none
      
      case let .comment(id, action: .writeCommentToggle):
        guard let comment = state.comments[id: id]?.comment else {
          return .none
        }
        
        state.commentMode = .writeReply(commentID: comment.id)
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
          
          switch state.commentMode {
          case let .writeComment(voteID):
            try await commentRepo.write(voteID: voteID, text: text)
          case let .editComment(commentID):
            try await commentRepo.edit(commentID: commentID, text: text)
          case let .writeReply(commentID):
            try await commentRepo.writeReply(commentID: commentID, text: text)
          case .none:
            break
          }

          await send(.requestComments)
          await send(.reset)
        } catch: { error, send in
          await toastManager.showToast(.error("댓글 작성중 문제가 발생했어요"))
        }
        
      case .reset:
        state.commentMode = .writeComment(voteID: state.voteID)
        state.text = ""
        return .none
      }
    }
    .forEach(\.comments, action: /Action.comment(id:action:)) {
      CommentCore()
    }
  }
}
