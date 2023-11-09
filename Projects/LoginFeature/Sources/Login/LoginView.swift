import SwiftUI
import AuthenticationServices

import ComposableArchitecture
import UI

import KakaoSDKUser

public struct LoginView: View {
  let store: StoreOf<LoginCore>
  @ObservedObject var viewStore: ViewStoreOf<LoginCore>
  
  public init(store: StoreOf<LoginCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    ZStack {
      
      VStack(spacing: 12) {
        Spacer()
        
        KakaoButton
        AppleButton
      }
    }
    .padding(.horizontal, 20)
    .navigationBarBackButtonHidden()
  }
}

private extension LoginView {
  var KakaoButton: some View {
    Button {
      store.send(.tapKakaoLogin)
    } label: {
      ZStack(alignment: .leading) {
        Text("카카오로 계속하기")
          .font(.system(size: 20, weight: .semibold))
          .foregroundColor(.ds(.black))
          .padding(.vertical, 20)
          .frame(maxWidth: .infinity)
          .frame(height: 56)
          .background(Color.ds(.yellow))
          .clipShape(Capsule())
        
        Image(icon: .ic_kakao)
          .fit(size: 32)
          .padding(.leading, 24)
      }
    }
  }
  
  var AppleButton: some View {
    Button {
      store.send(.tapAppleLogin)
    } label: {
      ZStack(alignment: .leading) {
        Text("Apple로 계속하기")
          .font(.system(size: 20, weight: .semibold))
          .foregroundColor(.ds(.black))
          .padding(.vertical, 20)
          .frame(maxWidth: .infinity)
          .frame(height: 56)
          .background(Color.ds(.white))
          .clipShape(Capsule())
        
        Image(icon: .ic_apple)
          .fit(size: 32)
          .padding(.leading, 24)
      }
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(store: .init(initialState: LoginCore.State()) {
      LoginCore()
    })
    .preferredColorScheme(.dark)
    .previewLayout(.sizeThatFits)
  }
}

