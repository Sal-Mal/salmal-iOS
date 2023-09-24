import SwiftUI
import UI

@main
struct MainFeatureApp: App {
  
  init() {
    SM.Font.initFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
