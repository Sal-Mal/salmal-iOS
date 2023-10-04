import SwiftUI
import UI

struct ToastView: View {

  @State private var toast: SMToast?

  var body: some View {
    List {
      Button {
        toast = SMToast(type: .success("토스트 테스트 메시지입니다."))
      } label: {
        Text("[성공] 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }

      Button {
        toast = SMToast(type: .warning("토스트 테스트 메시지입니다."))
      } label: {
        Text("[경고] 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }

      Button {
        toast = SMToast(type: .error("토스트 테스트 메시지입니다."))
      } label: {
        Text("[에러] 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }

      Button {
        toast = SMToast(type: .success("테스트"))
      } label: {
        Text("짧은 글 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }

      Button {
        toast = SMToast(type: .success("토스트 테스트 메시지입니다. 토스트 테스트 메시지입니다."))
      } label: {
        Text("긴 글 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }
    }
    .navigationTitle("토스트")
    .toast(on: $toast)
  }
}

struct ToastView_Previews: PreviewProvider {
  static var previews: some View {
    ToastView()
  }
}
