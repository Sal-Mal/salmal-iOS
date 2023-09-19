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
      LoginView(store: .init(initialState: .init()) {
        LoginCore()
      })
      .preferredColorScheme(.dark)
    }
  }
}
