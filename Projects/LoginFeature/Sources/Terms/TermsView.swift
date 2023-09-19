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
        .padding(.top, 160)
      
      Spacer()
      
      VStack(spacing: 44) {
        Terms
          .padding(.horizontal, 4)

        NavigationLink(state: LoginCore.Path.State.signUpScreen(.init())) {
          SMBoxLabel(title: "다음")
            .disabled(!viewStore.nextButtonState)
        }
      }
    }
    .padding(.horizontal, 18)
    .navigationBarBackButtonHidden()
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
    VStack(spacing: 0) {
      TermRow(title: "약관 전체동의", isChecked: viewStore.binding(get: \.all, send: { _ in .toggleAll}))
      TermRow(title: "이용약관동의(필수)", isChecked: viewStore.$termsOfUse) { }
      TermRow(title: "개인정보 수집 및 이용동의(필수)", isChecked: viewStore.$personalInformation) { }
      TermRow(title: "E-mail 및 SMS 광고성 정보 수신동의(선택)", isChecked: viewStore.$marketing) { }
    }
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

