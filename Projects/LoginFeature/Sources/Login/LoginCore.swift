import ComposableArchitecture
import Core

public struct LoginCore: Reducer {
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case saveSocialData(id: String, provider: String)
    case requestAutoLogin(String)
    case moveToTermScreen
  }
  
  public init() {}
  
  @Dependency(\.userDefault) var userDefault
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {

      case let .saveSocialData(id, provider):
        userDefault.socialID = id
        userDefault.socialProvider = provider
        return .send(.requestAutoLogin(id))
        
      case let .requestAutoLogin(id):

        return .run { send in
          let dto = try await network.request(AuthAPI.logIn(id: id), type: TokenDTO.self)
          userDefault.accessToken = dto.accessToken
          userDefault.refreshToken = dto.refreshToken
          NotiManager.post(.login)
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
