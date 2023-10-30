import SwiftUI
import PhotosUI
import ComposableArchitecture

import Core
import UI

struct SignUpView: View {
  
  let store: StoreOf<SignUpCore>
  @ObservedObject var viewStore: ViewStoreOf<SignUpCore>
  @FocusState private var isFocused: Bool
  
  init(store: StoreOf<SignUpCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        Image(icon: .ic_profile)
          .fit(size: 89)
          .padding(.bottom, 48)
        
        TextArea
      }
      
      VStack(spacing: 0) {
        Spacer()
        
        if let errorMessage = viewStore.errorMessage {
          Text(errorMessage)
            .foregroundColor(.ds(.white))
            .font(.ds(.title4(.medium)))
            .padding(.bottom, 18)
        }

        SMBoxButton(title: "확인") {
          store.send(.tapConfirmButton)
        }
        .disabled(!viewStore.isConfirmButtonEnabled)
      }
    }
    .padding(.horizontal, 18)
    .navigationBarBackButtonHidden()
    .contentShape(Rectangle())
    .onTapGesture {
      isFocused = false
    }
  }
}

private extension SignUpView {
  
  @ViewBuilder
  var TextArea: some View {
    Text("닉네임")
      .foregroundColor(.ds(.white36))
      .font(.ds(.title4(.medium)))
    
    TextField(
      "",
      text: viewStore.binding(
        get: \.text,
        send: SignUpCore.Action.textChanged
      ),
      prompt: Text("눌러서 입력")
        .foregroundColor(.ds(.green1))
        .font(.ds(.title2(.semibold)))
    )
    .tint(.ds(.green1))
    .foregroundColor(.ds(.green1))
    .frame(height: 60)
    .multilineTextAlignment(.center)
    .focused($isFocused)
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(store: .init(initialState: .init(marketingAgreement: true)) {
      SignUpCore()
    })
      .preferredColorScheme(.dark)
  }
}
