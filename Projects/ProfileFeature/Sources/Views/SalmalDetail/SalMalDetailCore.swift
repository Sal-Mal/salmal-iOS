import UI
import Core

import ComposableArchitecture

public struct SalMalDetailCore: Reducer {
  public typealias ButtonState = SMVoteButton.ButtonState
  
  public struct State: Equatable {
    var vote: Vote
    
    @BindingState var salButtonState: ButtonState = .idle
    @BindingState var malButtonState: ButtonState = .idle
    
    @BindingState var buyPercentage: Double
    @BindingState var notBuyPercentage: Double
    
    @PresentationState var commentListState: CommentListCore.State?
    @PresentationState var reportState: ReportCore.State?
    
    var isMine: Bool {
      return UserDefaultsService.shared.memberID == vote.memberID
    }
    
    public init(vote: Vote) {
      self.vote = vote
      
      if vote.totalVoteCount == 0 {
        buyPercentage = 0
        notBuyPercentage = 0
      } else {
        buyPercentage = Double(vote.likeCount) / Double(vote.totalVoteCount)
        notBuyPercentage = Double(vote.disLikeCount) / Double(vote.totalVoteCount)
      }
    }
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case report(PresentationAction<ReportCore.Action>)
    case commentList(PresentationAction<CommentListCore.Action>)
    
    case bookmarkTapped
    case commentTapped
    case backButtonTapped
    case deleteVoteTapped
    case moreTapped
    case profileTapped
    case setVoteStatus(Vote.VoteStatus)
    case salButtonTapped
    case malButtonTapped
    case requestVote(id: Int)
    case update(Vote)
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.toastManager) var toastManager
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .report:
        return .none
        
      case .commentList:
        return .none
        
      case .bookmarkTapped:
        return .run { [vote = state.vote] send in
          if vote.isBookmarked {
            try await voteRepository.unBookmark(voteID: vote.id)
          } else {
            try await voteRepository.bookmark(voteID: vote.id)
          }
          
          await send(.requestVote(id: vote.id))
          
        } catch: { error, send in
          await toastManager.showToast(.error("북마크 변경에 실패했어요"))
        }
        
      case .commentTapped:
        state.commentListState = .init(voteID: state.vote.id, commentCount: state.vote.commentCnt)
        return .none
        
      case .backButtonTapped:
        return .run { send in
          await dismiss()
        }
        
      case .deleteVoteTapped:
        return .run { [id = state.vote.id] send in
          try await voteRepository.delete(voteID: id)
          await dismiss()
        } catch: { error, send in
          await toastManager.showToast(.error("살말 삭제에 실패했어요"))
        }
        
      case .moreTapped:
        state.reportState = .init(voteID: state.vote.id, memberID: state.vote.memberID)
        return .none
      
      case .profileTapped:
        // TODO: Move To Profile
        return .none
        
      case let .setVoteStatus(value):
        switch value {
        case .like:
          state.salButtonState = .selected
          state.malButtonState = .unSelected
          
        case .disLike:
          state.salButtonState = .unSelected
          state.malButtonState = .selected
          
        case .none:
          state.salButtonState = .idle
          state.malButtonState = .idle
        }
        
        return .none
        
      case .salButtonTapped:
        
        
        return .none
        
      case .malButtonTapped:
        return .none
        
      case let .requestVote(id):
        return .run { send in
          let vote = try await voteRepository.getVote(id: id)
          await send(.update(vote))
        } catch: { error, send in
          // TODO: Vote 업데이트 실패
        }
        
      case let .update(vote):
        state.vote = vote
        return .none
      }
    }
    .ifLet(\.$commentListState, action: /Action.commentList) {
      CommentListCore()
    }
    .ifLet(\.$reportState, action: /Action.report) {
      ReportCore()
    }
  }
}
