import SwiftUI
import PhotosUI

import Core
import ComposableArchitecture

struct SignUpCore: Reducer {
  struct State: Equatable {
    var text: String = ""
    var errorMessage: String?
    var imageData: Data?
    
    @BindingState var selectedItem: PhotosPickerItem?
    
    var isConfirmButtonEnabled: Bool {
      imageData != nil && (1...20).contains(text.count)
    }
  }
  
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case textChanged(text: String)
    case tapConfirmButton
    case setImage(Data?)
    case setErrorMessage(String)
  }
  
  @Dependency(\.network) var network
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        if let item = state.selectedItem {
          return .run { send in
            let data = try await item.loadTransferable(type: Data.self)
            await send(.setImage(data))
          }
        }
        
        return .none
        
      case let .textChanged(text):
        state.text = text
        
        if text.count >= 20 {
          state.errorMessage = "20자 미만으로 써주세요"
        } else {
          state.errorMessage = nil
        }
        
        return .none
        
      case .tapConfirmButton:
        return .run { [state] send in
          // TODO: UserDefault
          let model = SignUpDTO(
            providerId: "",
            nickName: state.text,
            marketingInformationConsent: true
          )
          let api = AuthAPI.signUp(id: "kakao", body: model)
          let dto = try await network.request(api, type: TokenDTO.self)
          // TODO: SaveToken
        } catch: { error, send in
          // TODO: 에러처리
        }
        
      case let .setImage(data):
        state.imageData = data
        return .none
        
      case let .setErrorMessage(text):
        state.errorMessage = text
        return .none
      }
    }
  }
}
