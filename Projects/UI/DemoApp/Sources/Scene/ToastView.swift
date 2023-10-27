import SwiftUI

import UI
import ComposableArchitecture

struct ToastView: View {

  @Dependency(\.toastManager) var toastManager

  var body: some View {
    List {
      Button {
        toastManager.showToast(.success("토스트 테스트 메시지입니다."))
      } label: {
        Text("[성공] 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }

      Button {
        toastManager.showToast(.warning("토스트 테스트 메시지입니다."))
      } label: {
        Text("[경고] 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }

      Button {
        toastManager.showToast(.error("토스트 테스트 메시지입니다."))
      } label: {
        Text("[에러] 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }

      Button {
        toastManager.showToast(.success("테스트"))
      } label: {
        Text("짧은 글 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }

      Button {
        toastManager.showToast(.success("토스트 테스트 메시지입니다. 토스트 테스트 메시지입니다."))
      } label: {
        Text("긴 글 토스트")
          .font(.ds(.title3(.medium)))
          .foregroundColor(.ds(.black))
      }
    }
    .navigationTitle("토스트")
  }
}

struct ToastView_Previews: PreviewProvider {
  static var previews: some View {
    ToastView()
  }
}
