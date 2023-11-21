import ComposableArchitecture
import Core

public struct LoginCore: Reducer {
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case tapAppleLogin
    case tapKakaoLogin
    case saveSocialData(id: String, provider: String)
    case requestLogin(String)
    case moveToTermScreen
  }
  
  public init() {}
  
  @Dependency(\.toastManager) var toastManager
  @Dependency(\.userDefault) var userDefault
  @Dependency(\.kakaoManager) var kakaoManager
  @Dependency(\.appleManager) var appleManager
  @Dependency(\.authRepository) var authRepository
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tapKakaoLogin:
        return .run { send in
          let id = try await kakaoManager.logIn()
          await send(.saveSocialData(id: String(id), provider: "kakao"))
        } catch: { error, send in
          await toastManager.showToast(.error("카카오 로그인 실패"))
        }
        
      case .tapAppleLogin:
        return .run { send in
          let id = try await appleManager.requestLogin()
          await send(.saveSocialData(id: id, provider: "apple"))
        } catch: { error, send in
          await toastManager.showToast(.error("애플 로그인 실패"))
        }

      case let .saveSocialData(id, provider):
        userDefault.socialID = id
        userDefault.socialProvider = provider
        return .send(.requestLogin(id))
        
      case let .requestLogin(id):
        return .run { send in
          try await authRepository.logIn(providerID: id)
          
          NotificationService.post(.login)
        } catch: { error, send in
          // 로그인 실패했으면 회원가입 flow
          await send(.moveToTermScreen)
        }
        
      case .moveToTermScreen:
        return .none
      }
    }
  }
}
