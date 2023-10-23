import ComposableArchitecture
import Core

public struct LoginCore: Reducer {
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case tapKakaoLogin
    case tapAppleLogin
    case saveSocialData(id: String, provider: String)
    case requestLogin(String)
    case moveToTermScreen
  }
  
  public init() {}
  
  @Dependency(\.userDefault) var userDefault
  @Dependency(\.network) var network
  @Dependency(\.kakaoManager) var kakaoManager
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tapKakaoLogin:
        return .run { send in
          let id = try await kakaoManager.logIn()
          await send(.saveSocialData(id: String(id), provider: "kakao"))
        } catch: { error, send in
          // TODO: ToastMessage
          debugPrint("로그인 실패")
        }
        
      case .tapAppleLogin:
        return .none

      case let .saveSocialData(id, provider):
        userDefault.socialID = id
        userDefault.socialProvider = provider
        return .send(.requestLogin(id))
        
      case let .requestLogin(id):
        return .run { send in
          let model = LoginRequestDTO(providerId: id)
          let api = AuthAPI.logIn(params: model)
          let dto = try await network.request(api, type: TokenResponseDTO.self)
          
          userDefault.accessToken = dto.accessToken
          userDefault.refreshToken = dto.refreshToken
          
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
