import ComposableArchitecture
import LoginFeature
import Core

struct AppCore: Reducer {
  struct State: Equatable {
    var splashState: SplashCore.State? = .init()
    var mainState: MainTabCore.State?
  }
  
  enum Action {
    case splash(SplashCore.Action)
    case main(MainTabCore.Action)
    
    // MARK: - Internal Action
    case _setLogin(Bool)
  }
  
  @Dependency(\.notificationRepository) var notiRepo
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .splash, .main:
        break
        
      case let ._setLogin(value):
        if value {
          state.splashState = nil
          state.mainState = .init()
          
          return .run { send in
            if let fcmToken = UserDefaultsService.shared.fcmToken {
              try await notiRepo.registerFCM(token: fcmToken)
            }
          }
          
        } else {
          state.splashState = .init()
          state.mainState = nil
        }
      }
      
      return .none
    }
    .ifLet(\.splashState, action: /Action.splash) {
      SplashCore()
    }
    .ifLet(\.mainState, action: /Action.main) {
      MainTabCore()
    }
  }
}
