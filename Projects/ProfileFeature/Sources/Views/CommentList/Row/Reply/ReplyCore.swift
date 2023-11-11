import Core
import UI

import ComposableArchitecture

public struct ReplyCommentCore: Reducer {
  public struct State: Equatable, Identifiable {
    var comment: Comment
    
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
    
    public var id: Int {
      return comment.id
    }
  }
  
  public enum Action: Equatable {
    case delegate(Delegate)
    case optionsTapped
    case likeTapped
    case setLiked(to: Bool)
    
    public enum Delegate: Equatable {
      
    }
  }
  
  @Dependency(\.commentRepository) var commentRepository
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
        
      case .optionsTapped:
        return .none
        
      case .likeTapped:
        return .run { [state] send in
          // 좋아요 해제하기
          if state.comment.liked {
            await send(.setLiked(to: false))
            try await commentRepository.disLike(commentID: state.comment.id)
          }
          // 좋아요 누르기
          else {
            await send(.setLiked(to: true))
            try await commentRepository.like(commentID: state.comment.id)
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
  }
}
