import SwiftUI
import UI

@main
struct UIApp: App {

  init() {
    // 프로세스에 폰트들을 등록
    SM.Font.initFonts()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
