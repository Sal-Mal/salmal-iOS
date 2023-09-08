import SwiftUI

enum Demo: String, CaseIterable {
  case fonts = "Fonts"
  case colors = "Colors"
  case navigation = "Navigation"
  
  @ViewBuilder var content: some View {
    switch self {
    case .fonts:
      FontView()
    case .colors:
      ColorView()
    case .navigation:
      NavigationView()
    }
  }
}

struct ContentView: View {
  
  var body: some View {
    NavigationStack {
      List(Demo.allCases, id: \.rawValue) { demo in
        NavigationLink(demo.rawValue, destination: demo.content)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
