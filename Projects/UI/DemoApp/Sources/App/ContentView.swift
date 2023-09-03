import SwiftUI

enum DemoMenu: String {
  case fonts = "Fonts"
  case colors = "Colors"
}

struct ContentView: View {

  var menus: [DemoMenu] = [.fonts, .colors]

  var body: some View {
    NavigationView {
      List(menus, id: \.rawValue) { menu in
        switch menu {
        case .fonts:
          NavigationLink(menu.rawValue, destination: FontView())
        case .colors:
          NavigationLink(menu.rawValue, destination: ColorView())
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
