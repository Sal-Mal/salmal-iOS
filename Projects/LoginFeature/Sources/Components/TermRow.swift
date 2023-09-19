import SwiftUI
import UI

struct TermRow: View {
  let title: String
  @Binding var isChecked: Bool
  let tapAction: (() -> Void)?
  
  init(title: String, isChecked: Binding<Bool>, tapAction: (() -> Void)? = nil) {
    self.title = title
    self._isChecked = isChecked
    self.tapAction = tapAction
  }
  
  var body: some View {
    HStack(spacing: 10) {
      Image(icon: .ic_check)
        .fit(size: 16)
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 4).fill(isChecked ? Color.ds(.green1) : Color.ds(.gray3)))
        .onTapGesture {
          isChecked.toggle()
        }
      
      Text(title)
        .font(.ds(.title3(.medium)))
        .foregroundColor(.ds(.white))
      Spacer()
    }
    .frame(height: 60)
    .frame(maxWidth: .infinity)
  }
}

struct TermRow_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 0) {
      TermRow(title: "약관 전체동의", isChecked: .constant(true), tapAction: {})
      TermRow(title: "약관 전체동의", isChecked: .constant(false), tapAction: {})
      TermRow(title: "약관 전체동의", isChecked: .constant(false), tapAction: {})
      TermRow(title: "약관 전체동의", isChecked: .constant(true), tapAction: {})
    }
    .padding()
    .preferredColorScheme(.dark)
  }
}
