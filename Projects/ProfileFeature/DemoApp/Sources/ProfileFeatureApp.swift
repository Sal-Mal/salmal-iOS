import SwiftUI

import UI
import ProfileFeature

@main
struct ProfileFeatureApp: App {

  init() {
    SM.Font.initFonts()
  }

  var body: some Scene {
    WindowGroup {
      ProfileView(store: .init(initialState: .init(), reducer: {
        ProfileCore()
      }))
    }
  }
}
