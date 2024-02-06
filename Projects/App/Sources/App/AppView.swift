import SwiftUI

import Core
import LoginFeature
import ComposableArchitecture

struct AppView: View {
  @Dependency(\.kakaoManager) var kakaoManager
  @StateObject var appState = AppState.shared
  
  let store: StoreOf<AppCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      IfLetStore(store.scope(state: \.splashState, action: { .splash($0)})) { subStore in
        SplashView(store: subStore)
          .environmentObject(appState)
      }
      
      IfLetStore(store.scope(state: \.mainState, action: { .main($0)})) { subStore in
        MainTabView(store: subStore)
          .environmentObject(appState)
      }
    }
    .onOpenURL(perform: kakaoManager.openURL)
    .preferredColorScheme(.dark)
    .onReceive(NotificationService.publisher(.login)) { _ in
      store.send(._setLogin(true))
    }
    .onReceive(NotificationService.publisher(.logout)) { _ in
      store.send(._setLogin(false))
    }
  }
}
