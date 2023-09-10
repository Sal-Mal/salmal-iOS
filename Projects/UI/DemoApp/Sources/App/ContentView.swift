import SwiftUI

enum Demo: String, CaseIterable {
  case fonts = "폰트"
  case colors = "컬러"
  case toasts = "토스트"
  case bottomSheet = "바텀시트"
  case textField = "텍스트필드"

  @ViewBuilder var content: some View {
    switch self {
    case .fonts:
      FontView()
    case .colors:
      ColorView()
    case .toasts:
      ToastView()
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
