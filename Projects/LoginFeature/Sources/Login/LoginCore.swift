import ComposableArchitecture
import Core

public struct LoginCore: Reducer {
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case saveSocialData(id: String, provider: String)
    case requestLogin(String)
    case moveToTermScreen
  }
  
  public init() {}
  
  @Dependency(\.userDefault) var userDefault
  @Dependency(\.authRepository) var authRepository
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {

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
