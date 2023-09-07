import SwiftUI

enum Demo: String, CaseIterable {
  case fonts = "Fonts"
  case colors = "Colors"
  case bottomSheet = "BottomSheet"
  case textField = "TextField"

  @ViewBuilder var content: some View {
    switch self {
    case .fonts:
      FontView()
    case .colors:
      ColorView()
    case .bottomSheet:
      BottomSheetView()
    case .textField:
      TextFieldView()
    }
  }
}

struct ContentView: View {

  var body: some View {
    NavigationView {
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
