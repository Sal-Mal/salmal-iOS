import Alamofire

import Core
import ComposableArchitecture

public struct SignUpCore: Reducer {
  public struct State: Equatable {
    var text: String = ""
    var errorMessage: String?
    
    var isConfirmButtonEnabled: Bool {
      (1...20).contains(text.count)
    }
    
    let marketingAgreement: Bool
    
    public init(marketingAgreement: Bool) {
      self.marketingAgreement = marketingAgreement
    }
  }
  
  public enum Action: Equatable {
    case textChanged(text: String)
    case tapConfirmButton
    case setErrorMessage(String)
  }
  
  public init() {}
  
  @Dependency(\.userDefault) var userDefault
  @Dependency(\.authRepository) var authRepository
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
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
              let provider = userDefault.socialProvider
        else {
          return .none
        }
        
        return .run { [state] send in
          
          try await authRepository.signUp(
            socialProvider: provider,
            providerID: id,
            nickName: state.text,
            marketingInformationConsent: state.marketingAgreement
          )

          NotificationService.post(.login)
        } catch: { error, send in
          // TODO: 에러처리 (중복 id, 통신 실패)
          print(error)
        }
        
      case let .setErrorMessage(text):
        state.errorMessage = text
        return .none
      }
    }
  }
}
