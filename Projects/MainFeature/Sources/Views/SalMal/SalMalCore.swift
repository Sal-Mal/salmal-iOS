import UI
import ComposableArchitecture

public struct SalMalCore: Reducer {
  public typealias ButtonState = SMVoteButton.ButtonState
  public typealias Tab = SMMainNavigationBar.Tab
  
  public struct State: Equatable {
    @BindingState var tab: Tab = .home
    
    var buyPercentage: Double = 0
    var notBuyPercentage: Double = 0
    var totalCount = 0
    
    @BindingState var salButtonState: ButtonState = .idle
    @BindingState var malButtonState: ButtonState = .idle
    
    var homeState = CarouselCore.State(tab: .home)
    var bestState = CarouselCore.State(tab: .best)
    
    public init() {}
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case homeAction(CarouselCore.Action)
    case bestAction(CarouselCore.Action)
    case salButtonAction(ButtonState)
    case malButtonAction(ButtonState)
    case moveToAlarm
    case buyTapped
    case notBuyTapped
  }
  
  public init() { }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case let .homeAction(.delegate(.updateVote(vote))):
        state.totalCount = vote.totalVoteCount
        state.buyPercentage = Double(vote.likeCount) / Double(vote.totalVoteCount)
        state.notBuyPercentage = Double(vote.disLikeCount) / Double(vote.totalVoteCount)
        
        state.salButtonState = .idle
        state.malButtonState = .idle

        return .none
        
      case let .bestAction(.delegate(.updateVote(vote))):
        state.totalCount = vote.totalVoteCount
        state.buyPercentage = Double(vote.likeCount) / Double(vote.totalVoteCount)
        state.notBuyPercentage = Double(vote.disLikeCount) / Double(vote.totalVoteCount)
        
        state.salButtonState = .idle
        state.malButtonState = .idle
        
        return .none
        
      case .moveToAlarm:
        // TODO: 알람화면으로 이동
        return .none
        
      case .buyTapped:
        switch state.salButtonState {
        case .idle:
          state.salButtonState = .selected
          state.malButtonState = .unSelected
        case .selected:
          state.salButtonState = .idle
          state.malButtonState = .idle
        case .unSelected:
          state.salButtonState = .selected
          state.malButtonState = .unSelected
        }
        
        return .none
        
      case .notBuyTapped:
        switch state.malButtonState {
        case .idle:
          state.salButtonState = .unSelected
          state.malButtonState = .selected
        case .selected:
          state.salButtonState = .idle
          state.malButtonState = .idle
        case .unSelected:
          state.salButtonState = .unSelected
          state.malButtonState = .selected
        }
        return .none
        
      default:
        return .none
      }
    }
    
    Scope(state: \.homeState, action: /Action.homeAction) {
      CarouselCore()
    }
    
    Scope(state: \.bestState, action: /Action.bestAction) {
      CarouselCore()
    }
  }
}
