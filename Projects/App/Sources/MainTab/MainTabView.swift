import SwiftUI
import Combine
import StoreKit

import ComposableArchitecture
import UI
import Core

import MainFeature
import ProfileFeature
import UploadFeature

struct MainTabView: View {
  let store: StoreOf<MainTabCore>
  
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack(alignment: .bottom) {
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
        .opacity(appState.showTab ? 1 : 0)
      }
      .onReceive(appState.$alarmData) {
        store.send(._receivePushAlarm($0))
      }
      .fullScreenCover(
        store: store.scope(state: \.$uploadState, action: { .uploadAction($0)}),
        onDismiss: {
          NotificationService.post(.refreshSalMalList)
          if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive}) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
          }
        },
        content: { subStore in
          UploadView(store: subStore)
        }
      )
    }
  }
}
