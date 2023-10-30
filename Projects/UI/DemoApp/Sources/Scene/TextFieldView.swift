import SwiftUI
import UI

struct TextFieldView: View {
  @State var text1 = "dudu"
  @State var text2 = ""
  
  @FocusState var focus: Bool
  
  var body: some View {
    VStack(spacing: 40) {
      SMCapsuleTextField(text: $text1, placeholder: "")
        .title("닉네임")
      
      SMCapsuleTextField(text: $text2, placeholder: "눌러서 댓글 입력")
        .lineLimit(3)
      
      SMCapsuleTextField(text: $text2, placeholder: "FocusState 테스트", focus: _focus)
        .lineLimit(3)
      
      Button("Focus") {
        focus.toggle()
      }
    }
    .padding()
  }
}

struct TextFieldView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      TextFieldView()
    }
  }
}
