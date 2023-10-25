import Core
import ComposableArchitecture

public struct SplashCore: Reducer {
  public struct State: Equatable {
    var path = StackState<Path.State>()
    public init() { }
  }
  
  public enum Action: Equatable {
    case path(StackAction<Path.State, Path.Action>)
    case onAppeared
    case requestAutoLogin(String)
    case moveToLoginScreen
    case moveToMainScreen
  }
  
  public init() { }
  
  @Dependency(\.authRepository) var authRepository
  @Dependency(\.userDefault) var userDefault
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .path(action):
        switch action {
        case let .element(_, .termsScreen(.moveToSignUpScreen(agreement))):
          state.path.append(.signUpScreen(.init(marketingAgreement: agreement)))
          return .none
          
        case .element(_, .loginScreen(.moveToTermScreen)):
          state.path.append(.termsScreen())
          return .none
          
        default:
          return .none
        }
        
      case .onAppeared:
        if let id = userDefault.socialID {
          return .send(.requestAutoLogin(id))
        }
        
        return .send(.moveToLoginScreen)
        
      case let .requestAutoLogin(id):
        return .run { send in
          
          try await authRepository.logIn(providerID: id)
          
          await send(.moveToMainScreen)
        } catch: { error, send in
          await send(.moveToLoginScreen)
        }
        
      case .moveToLoginScreen:
        state.path.append(.loginScreen())
        return .none
        
      case .moveToMainScreen:
        NotificationService.post(.login)
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
  }
}

extension SplashCore {
  public struct Path: Reducer {
    public enum State: Equatable {
      case loginScreen(LoginCore.State = .init())
      case termsScreen(TermsCore.State = .init())
      case signUpScreen(SignUpCore.State)
      case termsDetailScreen(TermDetailCore.State)
    }
    
    public enum Action: Equatable {
      case loginScreen(LoginCore.Action)
      case termsScreen(TermsCore.Action)
      case signUpScreen(SignUpCore.Action)
      case termsDetailScreen(TermDetailCore.Action)
    }
    
    public var body: some ReducerOf<Self> {
      Scope(state: /State.loginScreen, action: /Action.loginScreen) {
        LoginCore()
      }
      
      Scope(state: /State.termsScreen, action: /Action.termsScreen) {
        TermsCore()
      }
      
      Scope(state: /State.signUpScreen, action: /Action.signUpScreen) {
        SignUpCore()
      }
      
      Scope(state: /State.termsDetailScreen, action: /Action.termsDetailScreen) {
        TermDetailCore()
      }
    }
  }
}
