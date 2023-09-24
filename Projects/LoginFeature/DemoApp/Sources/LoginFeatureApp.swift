import SwiftUI

import ComposableArchitecture
import LoginFeature
import UI

@main
struct LoginFeatureApp: App {
  
  init() {
    SM.Font.initFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      SplashView(store: .init(initialState: .init()) {
        SplashCore()
      })
      .preferredColorScheme(.dark)
    }
  }
}
