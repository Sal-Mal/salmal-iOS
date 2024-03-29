import SwiftUI
import UI
import Core

import ComposableArchitecture
import ProfileFeature

public struct SalMalView: View {
  let store: StoreOf<SalMalCore>
  @ObservedObject var viewStore: ViewStoreOf<SalMalCore>
  @EnvironmentObject var appState: AppState
  
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
            progress: viewStore.$buyPercentage,
            buttonState: viewStore.$salButtonState
          ) {
              store.send(.buyTapped)
          }
          
          SMVoteButton(
            title: "👎🏻 말",
            progress: viewStore.$notBuyPercentage,
            buttonState: viewStore.$malButtonState) {
              store.send(.notBuyTapped)
            }
        }
        .padding(2)
      }
      .padding(16)
      .padding(.bottom, 40)
      .onAppear {
        NotificationService.post(.showTabBar)
      }
      .smMainNavigationBar(
        selection: viewStore.$tab,
        isAlarmExist: viewStore.isAlarmExist
      ) {
        store.send(.moveToAlarm())
      }
      .onReceive(AppState.shared.$alarmData) { model in
        guard model?.step == .alarm else { return }
        
        Task {
          try await Task.sleep(nanoseconds: 1_000_000_000)
          store.send(.moveToAlarm(model))
        }
      }
    } destination: { state in
      switch state {
      case .alarmScreen:
        CaseLet(
          /SalMalCore.Path.State.alarmScreen,
           action: SalMalCore.Path.Action.alarmScreen) { store in
             AlarmView(store: store)
           }
        
      case .otherProfileScreen:
        CaseLet(
          /SalMalCore.Path.State.otherProfileScreen,
           action: SalMalCore.Path.Action.otherProfileScreen) { store in
             OtherProfileView(store: store)
           }
        
      case .salmalDetailScreen:
        CaseLet(
          /SalMalCore.Path.State.salmalDetailScreen,
           action: SalMalCore.Path.Action.salmalDetailScreen) { store in
             SalMalDetailView(store: store)
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
