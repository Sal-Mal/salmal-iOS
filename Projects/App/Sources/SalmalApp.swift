import SwiftUI

import ComposableArchitecture
import UI
import Core

import MainFeature
import LoginFeature

@main
struct SalmalApp: App {
  @State private var isLogined = false
  @Dependency(\.kakaoManager) var kakaoManager
  
  init() {
    SM.Font.initFonts()
    kakaoManager.initSDK()
  }
  
  var body: some Scene {
    WindowGroup {
      Group {
        if isLogined {
          SalMalView(store: .init(initialState: .init()) {
            SalMalCore()
          })
        } else {
          SplashView(store: .init(initialState: .init()) {
            SplashCore()
          })
        }
      }
      .onOpenURL(perform: kakaoManager.openURL)
      .preferredColorScheme(.dark)
      .onReceive(NotificationCenter.default.publisher(for: .init("login"))) { _ in
        isLogined = true
      }
      .onReceive(NotificationCenter.default.publisher(for: .init("logout"))) { _ in
        isLogined = false
      }
    }
  }
}
