import SwiftUI
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

public struct SalMalView: View {
  let store: StoreOf<SalMalCore>
  @ObservedObject var viewStore: ViewStoreOf<SalMalCore>
  
  public init(store: StoreOf<SalMalCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 13) {
      ZStack(alignment: .bottom) {
        if viewStore.tab == .home {
          CarouselView(store: store.scope(state: \.homeState, action: { .homeAction($0) }))
        }
        
        if viewStore.tab == .best {
          CarouselView(store: store.scope(state: \.bestState, action: { .bestAction($0) }))
        }
        
        NumberOfVotesView(number: viewStore.totalCount)
          .offset(y: 7)
      }

      VStack(spacing: 9) {
        SMVoteButton(title: "살", progress: viewStore.buyPercentage) {
          store.send(.buyTapped)
        }
        SMVoteButton(title: "말", progress: viewStore.notBuyPercentage) {
          store.send(.notBuyTapped)
        }
      }
      .padding(2)
    }
    .padding(16)
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
    NavigationStack {
      SalMalView(store: .init(initialState: SalMalCore.State()) {
        SalMalCore()
      })
    }
    .preferredColorScheme(.dark)
  }
}
