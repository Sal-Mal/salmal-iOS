import Core
import ComposableArchitecture

public struct CommentCore: Reducer {
  public struct State: Equatable, Identifiable {
    var comment: Comment
    var replys: IdentifiedArrayOf<ReplyCommentCore.State>
    @PresentationState var report: ReportCommentCore.State?
    
    var showMoreComment: Bool
    var timeDifference: String {
      let difference = comment.createdAt.timeIntervalSinceNow * -1
      
      let minute: Double = 60
      let hour: Double = minute * 60
      let day: Double = hour * 24
      
      switch difference {
      // days
      case day...:
        return "\(Int((difference / day).rounded()))일 전"
      case hour..<day:
        return "\(Int((difference / hour).rounded()))시간 전"
      case minute..<day:
        return "\(Int((difference / minute).rounded()))분 전"
      default:
        return "방금전"
      }
    }
    public var id: Int { return comment.id }
    
    public init(comment: Comment, isOpen: Bool = false) {
      self.comment = comment
      self.replys = []
      self.showMoreComment = isOpen
    }
  }
  
  public enum Action: Equatable {
    case delegate(Delegate)
    case report(PresentationAction<ReportCommentCore.Action>)
    case replyComment(id: ReplyCommentCore.State.ID, action: ReplyCommentCore.Action)
    
    case optionsTapped
    case moreCommentToggle
    case writeCommentToggle
    case likeTapped
    case requestReplys
    case setReplys(value: [Comment])
    case setLiked(to: Bool)
    
    public enum Delegate: Equatable {
      case refreshList
      case editComment(Comment)
    }
  }
  
  @Dependency(\.commentRepository) var commentRepo
  @Dependency(\.toastManager) var toastManager
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
        
      case let .report(.presented(.delegate(.editComment(comment)))):
        return .send(.delegate(.editComment(comment)))
        
      case .report(.presented(.delegate(.refreshList))):
        return .send(.delegate(.refreshList))
        
      case .report:
        return .none
        
      case let .replyComment(id: id, action: .optionsTapped):
        guard let reply = state.replys[id: id] else { return .none }
        state.report = .init(comment: reply.comment)
        
        return .none
        
      case .replyComment:
        return .none
        
      case .optionsTapped:
        state.report = .init(comment: state.comment)
        return .none
        
      // 답글 보기버튼 눌렀을떄
      case .moreCommentToggle:
        state.showMoreComment.toggle()
        
        if state.showMoreComment {
          return .send(.requestReplys)
        } else {
          state.replys = []
        }
        
        return .none
      
      // 답글 달기
      case .writeCommentToggle:
        NotificationService.post(.tapAddComment)
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
          await toastManager.showToast(.error("댓글 좋아요 실패"))
          await send(.setLiked(to: state.comment.liked))
        }
        
      case let .setLiked(to: value):
        state.comment.liked = value
        state.comment.likeCount += value ? 1 : -1
        
        return .none
        
      case .requestReplys:
        state.replys = []
        
        return .run { [state] send in
          let result = try await commentRepo.listReply(commentID: state.comment.id)
          await send(.setReplys(value: result))
        } catch: { error, send in
          await toastManager.showToast(.error("대댓글 조회 실패"))
        }
        
      case let .setReplys(value):
        state.replys = IdentifiedArray(uniqueElements: value.map {
          ReplyCommentCore.State(comment: $0)
        })
        return .none
      }
    }
    .forEach(\.replys, action: /Action.replyComment(id:action:)) {
      ReplyCommentCore()
    }
    .ifLet(\.$report, action: /Action.report) {
      ReportCommentCore()
    }
  }
}
