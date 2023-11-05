import SwiftUI
import UI

struct ButtonView: View {

  @State private var progress: Double = 0.6
  @State private var buttonState1: SMVoteButton.ButtonState = .idle
  @State private var buttonState2: SMVoteButton.ButtonState = .idle

  var body: some View {
    List {
      SMBoxButton(title: "버튼") {
        print("Box 버튼")
      }

      SMBoxButton(title: "버튼") {
        print("Box 버튼")
      }
      .disabled(true)

      SMBoxButton(title: "버튼", backgroundColor: .ds(.yellow)) {
        print("Box 버튼")
      }

      HStack {
        SMBoxButton(title: "버튼", buttonSize: .medium, foregroundColor: .ds(.white), backgroundColor: .ds(.red)) {
          print("Box 버튼")
        }

        SMBoxButton(title: "버튼", buttonSize: .medium, backgroundColor: .ds(.green)) {
          print("Box 버튼")
        }

        SMBoxButton(title: "버튼", buttonSize: .medium, backgroundColor: .ds(.blue)) {
          print("Box 버튼")
        }
      }

      SMCapsuleButton(title: "버튼", iconImage: Image(icon: .bookmark), foregroundColor: .white, backgroundColor: .black) {
        print("Box 버튼")
      }

      HStack {
        SMFloatingActionButton(iconImage: Image(icon: .ic_check), buttonSize: .medium, badgeCount: 3, backgroundColor: .ds(.green)) {
          print("Box 버튼")
        }

        SMFloatingActionButton(iconImage: Image(icon: .ic_check), buttonSize: .medium, badgeCount: 33, backgroundColor: .ds(.green)) {
          print("Box 버튼")
        }

        SMFloatingActionButton(iconImage: Image(icon: .ic_check), buttonSize: .medium, badgeCount: 333, backgroundColor: .ds(.green)) {
          print("Box 버튼")
        }

        SMFloatingActionButton(iconImage: Image(icon: .ic_check), buttonSize: .medium, badgeCount: 3333, backgroundColor: .ds(.green)) {
          print("Box 버튼")
        }
      }

      SMIconButton(iconImage: Image(icon: .camera), caption: "촬영", foregroundColor: .ds(.white), backgroundColor: .ds(.black)) {
        print("Box 버튼")
      }
      .padding()
      .background(.black)
      .cornerRadius(10)

      VStack {
        SMVoteButton(title: "👍🏻 살", progress: $progress, buttonState: $buttonState1) {
          buttonState1 = .selected
        }

        SMVoteButton(title: "👎🏻 말", progress: $progress, buttonState: $buttonState2) {
          buttonState2 = .unSelected
        }
      }
      .padding()
      .background(.black)
      .cornerRadius(16)

      Button {
        buttonState1 = .idle
        buttonState2 = .idle
      } label: {
        Text("초기화")
      }

    }
  }
}

struct ButtonViewProvider_Previews: PreviewProvider {
  static var previews: some View {
    ButtonView()
  }
}
