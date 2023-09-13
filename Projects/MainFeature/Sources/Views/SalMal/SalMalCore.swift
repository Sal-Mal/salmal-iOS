import UI
import ComposableArchitecture

public struct SalMalCore: Reducer {
  public struct State: Equatable {
    @BindingState var tab: SMMainNavigationBar.Tab = .home
    
    var buyPercentage: Double = 0
    var notBuyPercentage: Double = 0
    var totalCount = 0
    
    var homeState = CarouselCore.State(tab: .home)
    var bestState = CarouselCore.State(tab: .best)
    
    public init() {}
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case homeAction(CarouselCore.Action)
    case bestAction(CarouselCore.Action)
    case moveToAlarm
    case buyTapped
    case notBuyTapped
  }
  
  public init() { }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case let .homeAction(.delegate(.updateVote(total, buy, notBuy))):
        state.totalCount = total
        state.buyPercentage = Double(buy) / Double(total)
        state.notBuyPercentage = Double(notBuy) / Double(total)
        return .none
        
      case let .bestAction(.delegate(.updateVote(total, buy, notBuy))):
        state.totalCount = total
        state.buyPercentage = Double(buy) / Double(total)
        state.notBuyPercentage = Double(notBuy) / Double(total)
        return .none
        
      case .moveToAlarm:
        // TODO: 알람화면으로 이동
        return .none
        
      case .buyTapped:
        return .none
        
      case .notBuyTapped:
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
