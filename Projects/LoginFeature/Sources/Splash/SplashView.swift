import SwiftUI

import ComposableArchitecture
import Core
import UI

public struct SplashView: View {
  let store: StoreOf<SplashCore>
  @ObservedObject var viewStore: ViewStoreOf<SplashCore>
  
  public init(store: StoreOf<SplashCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: SplashCore.Action.path)) {
      ZStack {
        Image(icon: .ic_salmalApp)
          .fit(size: 150)
      }
    } destination: { state in
      switch state {
      case .loginScreen:
        CaseLet(
          /SplashCore.Path.State.loginScreen,
           action: SplashCore.Path.Action.loginScreen,
           then: LoginView.init(store:)
        )
      case .termsScreen:
        CaseLet(
          /SplashCore.Path.State.termsScreen,
           action: SplashCore.Path.Action.termsScreen,
           then: TermsView.init(store:)
        )
      case .signUpScreen:
        CaseLet(
          /SplashCore.Path.State.signUpScreen,
           action: SplashCore.Path.Action.signUpScreen,
           then: SignUpView.init(store:)
        )
      case .termsDetailScreen:
        CaseLet(
          /SplashCore.Path.State.termsDetailScreen,
           action: SplashCore.Path.Action.termsDetailScreen,
           then: TermDetailView.init(store:)
        )
      }
    }
    .task {
      try! await Task.sleep(for: .seconds(2))
      store.send(.onAppeared)
    }
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView(store: .init(initialState: SplashCore.State()) {
      SplashCore()
    })
    .preferredColorScheme(.dark)
  }
}

