import UI
import Core

import ComposableArchitecture

struct SalMalDetailCore: Reducer {
  public typealias ButtonState = SMVoteButton.ButtonState
  
  struct State: Equatable {
    let vote: Vote
    
    var isMine: Bool {
      return UserDefaultsService.shared.memberID == vote.memberID
    }
    
    var buyPercentage: Double {
      if vote.totalVoteCount == 0 { return 0 }
      
      return Double(vote.likeCount) / Double(vote.totalVoteCount)
    }
    
    var notBuyPercentage: Double {
      if vote.totalVoteCount == 0 { return 0 }
      
      return Double(vote.disLikeCount) / Double(vote.totalVoteCount)
    }
    
    @BindingState var salButtonState: ButtonState = .idle
    @BindingState var malButtonState: ButtonState = .idle
    
    @PresentationState var commentListState: CommentListCore.State?
    @PresentationState var reportState: ReportCore.State?
  }
  
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case bookmarkTapped
    case commentTapped
    case backButtonTapped
    case deleteVoteTapped
    case moreTapped
    case profileTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.voteRepository) var voteRepository
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .bookmarkTapped:
        return .none
        
      case .commentTapped:
        return .none
        
      case .backButtonTapped:
        return .none
        
      case .deleteVoteTapped:
        return .none
        
      case .moreTapped:
        return .none
      
      case .profileTapped:
        return .none
      }
    }
  }
}
