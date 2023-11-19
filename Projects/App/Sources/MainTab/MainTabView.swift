import SwiftUI

import ComposableArchitecture
import UI
import Core

import MainFeature
import ProfileFeature
import UploadFeature

struct MainTabView: View {
  let store: StoreOf<MainTabCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        TabView(selection: viewStore.$tabIndex) {
          SalMalView(store: store.scope(
            state: \.salmalState,
            action: { .salmalAction($0) }
          ))
          .tag(TabItem.home)
          .toolbar(.hidden, for: .tabBar)
          
          ProfileView(store: store.scope(
            state: \.profileState,
            action: { .profileAction($0) }
          ))
          .tag(TabItem.profile)
          .toolbar(.hidden, for: .tabBar)
        }
        
        SalMalTabBar(tabIndex: viewStore.$tabIndex) {
          store.send(.uploadButtonTapped)
        }
        .frame(height: 52)
        .opacity(viewStore.showTab ? 1 : 0)
      }
      .onReceive(NotificationService.publisher(.showTabBar)) { _ in
        store.send(._setTabOpacity(true))
      }
      .onReceive(NotificationService.publisher(.hideTabBar)) { _ in
        store.send(._setTabOpacity(false))
      }
      .fullScreenCover(store: store.scope(
        state: \.$uploadState,
        action: { .uploadAction($0) }
      )) { subStore in
        UploadView(store: subStore)
      }
    }
  }
}
