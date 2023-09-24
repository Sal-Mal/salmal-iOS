import SwiftUI
import AuthenticationServices

import ComposableArchitecture
import UI

public struct LoginView: View {
  let store: StoreOf<LoginCore>
  @ObservedObject var viewStore: ViewStoreOf<LoginCore>
  
  public init(store: StoreOf<LoginCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack {
      Spacer()
      
      VStack(spacing: 12) {
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
      // TODO: kakao login
      store.send(.saveSocialData(id: "Sample-Kakao-Id", provider: "kakao"))
    } label: {
      Text("카카오톡 으로 시작하기")
        .foregroundColor(.ds(.black))
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Color.ds(.yellow))
        .clipShape(Capsule())
    }
  }
  
  var AppleButton: some View {
    SignInWithAppleButton(
      .continue,
      onRequest: { request in
        request.requestedScopes = [.fullName, .email]
      },
      onCompletion: { result in
        switch result {
        case let .success(auth):
          switch auth.credential {
          case let appIDCredential as ASAuthorizationAppleIDCredential:
            let id = appIDCredential.user
            print(id)
          default:
            break
          }
        case let .failure(error):
          print(error.localizedDescription)
        }
        
        // TODO: apple login
        store.send(.saveSocialData(id: "sample-apple-id", provider: "apple"))
      }
    )
    .signInWithAppleButtonStyle(.white)
    .clipShape(Capsule())
    .frame(height: 60)
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

