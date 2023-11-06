import SwiftUI

import UI
import UploadFeature

@main
struct UploadFeatureApp: App {

  init() {
    SM.Font.initFonts()
  }

  var body: some Scene {
    WindowGroup {
      UploadView(store: .init(initialState: .init(), reducer: {
        UploadCore()
          ._printChanges()
      }))
    }
  }
}
