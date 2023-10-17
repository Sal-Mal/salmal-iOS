import SwiftUI
import UI
import ComposableArchitecture

public struct SalMalView: View {
  let store: StoreOf<SalMalCore>
  @ObservedObject var viewStore: ViewStoreOf<SalMalCore>
  
  public init(store: StoreOf<SalMalCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {    
    NavigationStackStore(store.scope(state: \.path, action: SalMalCore.Action.path)) {
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
          SMVoteButton(
            title: "👍🏻 살",
            progress: viewStore.buyPercentage,
            buttonState: viewStore.$salButtonState
          ) {
            store.send(.buyTapped)
          }
          SMVoteButton(
            title: "👎🏻 말", progress:
              viewStore.notBuyPercentage,
            buttonState: viewStore.$malButtonState) {
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
    } destination: { state in
      switch state {
      case .alarmScreen:
        CaseLet(
          /SalMalCore.Path.State.alarmScreen,
           action: SalMalCore.Path.Action.alarmScreen) { store in
             AlarmView(store: store)
               .toolbar(.hidden, for: .tabBar)
           }
      }
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
