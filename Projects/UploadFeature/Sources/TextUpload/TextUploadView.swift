import SwiftUI
import ComposableArchitecture

import UI

public struct TextUploadView: View {

  @State var text: String = ""

  public init() {}

  public var body: some View {
    VStack {
      TextField(
        text: $text,
        label: {
          Text("텍스트 입력")
            .foregroundColor(.ds(.white80))
            .font(.ds(.title2(.medium)))
        }
      )
      .foregroundColor(.white)
      .font(.ds(.title2(.medium)))
      .tint(.ds(.green1))
      .multilineTextAlignment(.center)
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          PaletteView()
        }
      }
    }
    .frame(maxHeight: .infinity)
    .background(Color.ds(.black50))
    .smNavigationBar(
      title: "",
      leftItems: {
        Button {

        } label: {
          Text("취소")
            .foregroundColor(.ds(.white80))
            .font(.ds(.title2(.semibold)))
        }

      },
      rightItems: {
        Button {

        } label: {
          Text("확인")
            .foregroundColor(.ds(.green1))
            .font(.ds(.title2(.semibold)))
        }
      }
    )
  }
}

struct TextUploadView_Previews: PreviewProvider {
  static var previews: some View {
    TextUploadView()
  }
}
