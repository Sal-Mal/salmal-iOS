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
    VStack(spacing: 12) {
      Spacer()
      
      Button {
        
      } label: {
        Text("카카오톡 으로 시작하기")
          .foregroundColor(.ds(.black))
          .padding(.vertical, 20)
          .frame(maxWidth: .infinity)
          .background(Color.ds(.yellow))
          .clipShape(Capsule())
      }

      Button {
        
      } label: {
        Text("Apple로 시작하기")
          .foregroundColor(.ds(.black))
          .padding(.vertical, 20)
          .frame(maxWidth: .infinity)
          .background(Color.ds(.white))
          .clipShape(Capsule())
      }
    }
    .debug()
    .padding(.horizontal, 20)
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

