import SwiftUI
import ComposableArchitecture

import UI

public struct TermsView: View {
  let store: StoreOf<TermsCore>
  @ObservedObject var viewStore: ViewStoreOf<TermsCore>
  
  public init(store: StoreOf<TermsCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      WelcomeHeader
        .padding(.top, 120)
      
      Spacer()
      
      VStack(spacing: 44) {
        Terms
          .padding(.horizontal, 4)
          .frame(height: 240)
    
        SMBoxButton(title: "다음") {
          store.send(.moveToSignUpScreen(viewStore.marketing))
        }
        .disabled(!viewStore.nextButtonState)
      }
    }
    .padding(.horizontal, 18)
    .toolbar(.hidden, for: .navigationBar)
  }
}

private extension TermsView {
  var WelcomeHeader: some View {
    VStack(alignment: .leading, spacing: 12) {
      Image(icon: .ic_salmal)
        .fit(size: 94)
      Text("환영합니다!")
        .font(.ds(.title1))
        .foregroundColor(.ds(.white))
      
      Text("지금까지의 쇼핑 고민, 살말이 해결해드릴게요!")
        .font(.ds(.title3(.medium)))
        .foregroundColor(.ds(.gray2))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  var Terms: some View {
    List {
      TermRow(title: "약관 전체동의", isChecked: viewStore.binding(get: \.all, send: { _ in .toggleAll}))
        .listRowInsets(.init())
        .listRowSeparator(.hidden)
      
      NavigationLink(state: SplashCore.Path.State.termsDetailScreen(.init(
        title: "이용약관동의",
        url: "https://honorable-overcoat-a54.notion.site/1b14e3eedc6a4bf3ac8d4a7aad484328?pvs=4"))
      ) {
        TermRow(title: "이용약관동의(필수)", isChecked: viewStore.$termsOfUse)
      }
      .listRowInsets(.init())
      .listRowSeparator(.hidden)
      
      NavigationLink(state: SplashCore.Path.State.termsDetailScreen(.init(
        title: "개인정보 수집 및 이용동의",
        url: "https://honorable-overcoat-a54.notion.site/ff45b483da3942558a17c20dca1c4538?pvs=4")
      )) {
        TermRow(title: "개인정보 수집 및 이용동의(필수)", isChecked: viewStore.$personalInformation)
      }
      .listRowInsets(.init())
      .listRowSeparator(.hidden)
      
      NavigationLink(state: SplashCore.Path.State.termsDetailScreen(.init(
        title: "E-mail 및 SMS 광고성 정보 수신동의(선택)",
        url: "https://honorable-overcoat-a54.notion.site/8f5c915278a14733b90ef93a7e4af8ec?pvs=4")
      )) {
        TermRow(title: "E-mail 및 SMS 광고성 정보 수신동의(선택)", isChecked: viewStore.$marketing)
      }
      .listRowInsets(.init())
      .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
    .scrollDisabled(true)
  }
}

struct TermsView_Previews: PreviewProvider {
  static var previews: some View {
    TermsView(store: .init(initialState: TermsCore.State()) {
      TermsCore()
    })
    .preferredColorScheme(.dark)
  }
}

