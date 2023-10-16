import UI
import Core

import ComposableArchitecture

public struct SalMalCore: Reducer {
  public typealias ButtonState = SMVoteButton.ButtonState
  public typealias Tab = SMMainNavigationBar.Tab
  
  public struct State: Equatable {
    @BindingState var tab: Tab = .home
    
    var buyPercentage: Double = 0
    var notBuyPercentage: Double = 0
    var totalCount = 0
    
    var currentHomeIndex = 0
    var currentBestIndex = 0 
    
    @BindingState var salButtonState: ButtonState = .idle
    @BindingState var malButtonState: ButtonState = .idle
    
    var homeState = CarouselCore.State(tab: .home)
    var bestState = CarouselCore.State(tab: .best)
    var path = StackState<Path.State>()
    
    public init() {}
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case path(StackAction<Path.State, Path.Action>)
    case homeAction(CarouselCore.Action)
    case bestAction(CarouselCore.Action)
    case salButtonAction(ButtonState)
    case malButtonAction(ButtonState)
    case moveToAlarm
    case buyTapped
    case notBuyTapped
  }
  
  public init() { }
  
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case let .path(action):
        switch action {
        case let .element(_, .alarmScreen(.listTapped)):
          return .none
          
        default:
          return .none
        }
        
      case let .homeAction(.delegate(.updateVote(vote))):
        state.totalCount = vote.totalVoteCount
        
        if vote.totalVoteCount == 0 {
          state.buyPercentage = 0
          state.notBuyPercentage = 0
        } else {
          state.buyPercentage = Double(vote.likeCount) / Double(vote.totalVoteCount)
          state.notBuyPercentage = Double(vote.disLikeCount) / Double(vote.totalVoteCount)
        }
        
        state.salButtonState = .idle
        state.malButtonState = .idle
        
        return .none
        
      case let .bestAction(.delegate(.updateVote(vote))):
        state.totalCount = vote.totalVoteCount
        
        if vote.totalVoteCount == 0 {
          state.buyPercentage = 0
          state.notBuyPercentage = 0
        } else {
          state.buyPercentage = Double(vote.likeCount) / Double(vote.totalVoteCount)
          state.notBuyPercentage = Double(vote.disLikeCount) / Double(vote.totalVoteCount)
        }
        
        state.salButtonState = .idle
        state.malButtonState = .idle
        
        return .none
        
      case .moveToAlarm:
        state.path.append(.alarmScreen())
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
    .forEach(\.path, action: /Action.path) {
      Path()
    }
    
    Scope(state: \.homeState, action: /Action.homeAction) {
      CarouselCore()
    }
    
    Scope(state: \.bestState, action: /Action.bestAction) {
      CarouselCore()
    }
  }
}

extension SalMalCore {
  public struct Path: Reducer {
    public enum State: Equatable {
      case alarmScreen(AlarmCore.State = .init())
    }
    
    public enum Action: Equatable {
      case alarmScreen(AlarmCore.Action)
    }
    
    public var body: some ReducerOf<Self> {
      Scope(state: /State.alarmScreen, action: /Action.alarmScreen) {
        AlarmCore()
      }
    }
  }
}
