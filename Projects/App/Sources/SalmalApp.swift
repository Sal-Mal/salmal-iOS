import SwiftUI

import Core
import MainFeature
import LoginFeature

@main
struct SalmalApp: App {
  @State private var isLogined = false
  
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
