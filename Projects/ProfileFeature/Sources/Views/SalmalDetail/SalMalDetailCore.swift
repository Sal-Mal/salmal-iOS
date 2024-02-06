import UI
import Core

import ComposableArchitecture

public struct SalMalDetailCore: Reducer {
  public typealias ButtonState = SMVoteButton.ButtonState
  
  public struct State: Equatable {
    var vote: Vote
    var model: AppState.AlarmModel?
    
    @BindingState var salButtonState: ButtonState = .idle
    @BindingState var malButtonState: ButtonState = .idle
    
    @BindingState var buyPercentage: Double = 0
    @BindingState var notBuyPercentage: Double = 0
    
    @PresentationState var commentListState: CommentListCore.State?
    @PresentationState var reportState: ReportCore.State?
    
    var isMine: Bool {
      return UserDefaultsService.shared.memberID == vote.memberID
    }
    
    public init(vote: Vote, model: AppState.AlarmModel? = nil) {
      self.vote = vote
      self.model = model
    }
  }
  
  public init() {
    // empty
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case report(PresentationAction<ReportCore.Action>)
    case commentList(PresentationAction<CommentListCore.Action>)
    case delegate(Delegate)
    
    case bookmarkTapped
    case commentTapped
    case backButtonTapped
    case deleteVoteTapped
    case moreTapped
    case profileTapped
    case salButtonTapped
    case malButtonTapped
    case requestVote(id: Int)
    case update(Vote)
    case _showTargetComment
    
    
    public enum Delegate: Equatable {
      case moveToOtherProfile(Int)
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.notificationRepository) var notiRepository
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.toastManager) var toastManager
  @Dependency(\.userDefault) var userDefault
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .report:
        return .none
      case .commentList:
        return .none
      case .delegate:
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
        if state.vote.memberID != userDefault.memberID {
          return .send(.delegate(.moveToOtherProfile(state.vote.memberID)))
        }
        
        return .none
        
      case .salButtonTapped:
        return .run { [id = state.vote.id, state] send in
          switch state.salButtonState {
          case .idle:
            try await voteRepository.evaluate(
              voteID: id,
              param: .init(voteEvaluationType: .like)
            )
            await send(.requestVote(id: id))
            
          case .selected:
            try await voteRepository.unEvaluate(voteID: id)
            await send(.requestVote(id: id))
            
          case .unSelected:
            await toastManager.showToast(.error("이미 반대편에 투표했어요"))
          }
        } catch: { error, send in
          print(error.localizedDescription)
        }
        
      case .malButtonTapped:
        return .run { [id = state.vote.id, state] send in
          switch state.malButtonState {
          case .idle:
            try await voteRepository.evaluate(
              voteID: id,
              param: .init(voteEvaluationType: .dislike)
            )
            await send(.requestVote(id: id))
            
          case .selected:
            try await voteRepository.unEvaluate(voteID: id)
            await send(.requestVote(id: id))
            
          case .unSelected:
            await toastManager.showToast(.error("이미 반대편에 투표했어요"))
          }
        } catch: { error, send in
          print(error.localizedDescription)
        }
        
      case let .requestVote(id):
        return .run { send in
          let vote = try await voteRepository.getVote(id: id)
          await send(.update(vote))
        } catch: { error, send in
          // TODO: Vote 업데이트 실패
          print(error.localizedDescription)
        }
        
      case let .update(vote):
        state.vote = vote
        
        if vote.totalVoteCount == 0 {
          state.buyPercentage = 0
          state.notBuyPercentage = 0
        } else {
          state.buyPercentage = Double(vote.likeCount) / Double(vote.totalVoteCount)
          state.notBuyPercentage = Double(vote.disLikeCount) / Double(vote.totalVoteCount)
        }
        
        switch vote.voteStatus {
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
        
      case ._showTargetComment:
        guard let model = state.model else { return .none }
        
        return .run { send in
          await send(.commentTapped)
          try await notiRepository.readAlarm(id: model.alarmID)
        }
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
