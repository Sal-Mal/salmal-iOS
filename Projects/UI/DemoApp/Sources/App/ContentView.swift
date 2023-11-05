import SwiftUI

import UI
import ComposableArchitecture

enum Demo: String, CaseIterable {
  case fonts = "폰트"
  case colors = "컬러"
  case toasts = "토스트"
  case bottomSheet = "바텀시트"
  case textField = "텍스트필드"
  case navigation = "네비게이션"
  case button = "버튼"
  case tap = "탭"

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
    case .navigation:
      NavigationView()
    case .button:
      ButtonView()
    case .tap:
      TabView()
    }
  }
}


struct ContentView: View {

  @Dependency(\.toastManager) var tm
  

  var body: some View {
    NavigationStack {
      VStack {
        List(Demo.allCases, id: \.rawValue) { demo in
          NavigationLink(demo.rawValue, destination: demo.content)
        }

        Button("토스트 열기") {
          tm.showToast(.success("토스트 열기"))
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
