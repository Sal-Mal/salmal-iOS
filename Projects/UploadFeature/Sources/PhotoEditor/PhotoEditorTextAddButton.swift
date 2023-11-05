import SwiftUI

// 텍스트 추가 버튼
struct PhotoEditorTextAddButton: View {

  let action: () -> Void

  var body: some View {
    Button {
      action()
    } label: {
      HStack(spacing: 8) {
        Circle()
          .stroke(style: .init(lineWidth: 1, dash: [2]))
          .frame(width: 32, height: 32)
          .overlay {
            Image(icon: .plus)
              .renderingMode(.template)
              .foregroundColor(.ds(.white))
          }
        Text("텍스트 추가")
          .font(.ds(.title2(.medium)))
      }
      .tint(.ds(.white))
    }
  }
}
