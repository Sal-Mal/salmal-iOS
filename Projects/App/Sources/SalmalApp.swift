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
          SalMalView(store: .init(initialState: .init()) { SalMalCore() })
        } else {
          SplashView(store: .init(initialState: .init()) { SplashCore() })
        }
      }
      .onReceive(NotiManager.publisher(.login)) { _ in
        isLogined = true
      }
      .onReceive(NotiManager.publisher(.logout)) { _ in
        isLogined = false
      }
    }
  }
}
