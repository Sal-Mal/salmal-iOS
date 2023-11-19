import SwiftUI

import ComposableArchitecture
import UI
import Core

@main
struct SalmalApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @Dependency(\.kakaoManager) var kakaoManager
  
  let store: StoreOf<AppCore> = .init(initialState: .init()) { AppCore() }
  
  init() {
    SM.Font.initFonts()
    kakaoManager.initSDK()
  }
  
  var body: some Scene {
    WindowGroup {
      AppView(store: store)
    }
  }
}
