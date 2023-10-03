import SwiftUI
import PhotosUI
import Alamofire

import Core
import ComposableArchitecture

public struct SignUpCore: Reducer {
  public struct State: Equatable {
    var text: String = ""
    var errorMessage: String?
    var imageData: Data?
    
    @BindingState var selectedItem: PhotosPickerItem?
    
    var isConfirmButtonEnabled: Bool {
      imageData != nil && (1...20).contains(text.count)
    }
    
    let marketingAgreement: Bool
    
    public init(marketingAgreement: Bool) {
      self.marketingAgreement = marketingAgreement
    }
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case textChanged(text: String)
    case tapConfirmButton
    case setImage(Data?)
    case setErrorMessage(String)
  }
  
  public init() {}
  
  @Dependency(\.userDefault) var userDefault
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
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
        guard let id = userDefault.socialID,
              let provider = userDefault.socialProvider,
              let imageData = state.imageData
        else {
          return .none
        }
        
        let model = SignUpRequest(
          providerId: id,
          nickName: state.text,
          marketingInformationConsent: state.marketingAgreement
        )
        let api = AuthAPI.signUp(id: provider, params: model)
        
        print(model)
        
        return .run { send in
          let dto = try await network.request(api, type: TokenResponse.self)
          
          debugPrint(dto)
          userDefault.accessToken = dto.accessToken
          userDefault.refreshToken = dto.refreshToken
        } catch: { error, send in
          // TODO: 에러처리 (중복 id, 통신 실패)
          print(error)
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
