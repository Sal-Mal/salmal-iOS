import Core
import ComposableArchitecture

public struct CommentCore: Reducer {
  public struct State: Equatable, Identifiable {
    var comment: Comment
    var replys: IdentifiedArrayOf<ReplyCommentCore.State>
    @PresentationState var report: ReportCommentCore.State?
    
    var showMoreComment = false
    
    public init(comment: Comment) {
      self.comment = comment
      self.replys = []
    }
    
    public var id: Int {
      return comment.id
    }
  }
  
  public enum Action: Equatable {
    case delegate(Delegate)
    case report(PresentationAction<ReportCommentCore.Action>)
    case replayComment(id: ReplyCommentCore.State.ID, action: ReplyCommentCore.Action)
    case optionsTapped
    case moreCommentToggle
    case writeCommentToggle
    case likeTapped
    case setLiked(to: Bool)
    
    public enum Delegate: Equatable {
      case refreshList
      case editComment
    }
  }
  
  @Dependency(\.commentRepository) var commentRepo
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
        
      case .report(.presented(.delegate(.editComment))):
        return .send(.delegate(.editComment))
        
      case .report(.presented(.delegate(.refreshList))):
        return .send(.delegate(.refreshList))
        
      case .report:
        return .none
        
      case .replayComment:
        return .none
        
      case .optionsTapped:
        state.report = .init(commentID: state.comment.id)
        return .none
        
      case .moreCommentToggle:
        state.showMoreComment.toggle()
        return .none
        
      case .writeCommentToggle:
        return .none
        
      case .likeTapped:
        
        return .run { [state] send in
          // 좋아요 해제하기
          if state.comment.liked {
            await send(.setLiked(to: false))
            try await commentRepo.disLike(commentID: state.comment.id)
          }
          // 좋아요 누르기
          else {
            await send(.setLiked(to: true))
            try await commentRepo.like(commentID: state.comment.id)
          }
          
        } catch: { [state] error, send in
          // TODO: Show ToastMessage
          await send(.setLiked(to: state.comment.liked))
        }
        
      case let .setLiked(to: value):
        state.comment.liked = value
        state.comment.likeCount += value ? 1 : -1
        
        return .none
      }
    }
    .forEach(\.replys, action: /Action.replayComment(id:action:)) {
      ReplyCommentCore()
    }
    .ifLet(\.$report, action: /Action.report) {
      ReportCommentCore()
    }
  }
}
