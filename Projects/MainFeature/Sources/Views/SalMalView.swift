import SwiftUI
import UI
import ComposableArchitecture

public struct SalMalCore: Reducer {
  public struct State: Equatable {
    @BindingState var tab: SMMainNavigationBar.Tab = .home
    
    var buyPercentage: Double = 0
    var notBuyPercentage: Double = 0
    var totalCount = 0
    
    var carouselState = CarouselCore.State()
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case subAction(CarouselCore.Action)
    case moveToAlarm
    case buyTapped
    case notBuyTapped
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .moveToAlarm:
        return .none
        
      case .buyTapped:
        return .none
        
      case .notBuyTapped:
        return .none
        
      default:
        return .none
      }
    }
    
    Scope(state: \.carouselState, action: /Action.subAction) {
      CarouselCore()
    }
  }
}

public struct SalMalView: View {
  let store: StoreOf<SalMalCore>
  @ObservedObject var viewStore: ViewStoreOf<SalMalCore>
  
  public init(store: StoreOf<SalMalCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack {
      CarouselView(store: store.scope(state: \.carouselState, action: { .subAction($0) }))
      SMVoteButton(title: "살", progress: viewStore.buyPercentage) {
        store.send(.buyTapped)
      }
      SMVoteButton(title: "말", progress: viewStore.notBuyPercentage) {
        store.send(.notBuyTapped)
      }
    }
      .smMainNavigationBar(
        selection: viewStore.$tab,
        isAlarmExist: true
      ) {
        store.send(.moveToAlarm)
      }
  }
}

struct SalMalView_Previews: PreviewProvider {
  static var previews: some View {
    SalMalView(store: .init(initialState: SalMalCore.State()) {
      SalMalCore()
    })
  }
}
