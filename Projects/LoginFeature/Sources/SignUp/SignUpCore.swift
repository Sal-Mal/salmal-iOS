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
  
  @Dependency(\.toastManager) var toastManager
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
          guard let error = error as? SMError else {
            await toastManager.showToast(.error("회원가입 실패!"))
            return
          }
          
          if case let .network(.invalidURLHTTPResponse(code)) = error {
            switch code {
            case 1004:
              await toastManager.showToast(.error("닉네임의 최소 길이는 2, 최대 길이는 20입니다."))
            case 1005:
              await toastManager.showToast(.error("중복된 닉네임이 존재합니다"))
            case 1001:
              await toastManager.showToast(.error("회원을 차즐 수 없습니다."))
            default:
              await toastManager.showToast(.error("회원가입 실패!"))
            }
          }
        }
        
      case let .setErrorMessage(text):
        state.errorMessage = text
        return .none
      }
    }
  }
}
