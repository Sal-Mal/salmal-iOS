import ComposableArchitecture
import Core

public struct LoginCore: Reducer {
  public struct State: Equatable {
    var path = StackState<Path.State>()
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case path(StackAction<Path.State, Path.Action>)
    case moveToTerms(id: String, provider: String)
    case moveToSignUp
  }
  
  public init() {}
  
  @Dependency(\.userDefault) var userDefault
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .path:
        return .none
        
      case let .moveToTerms(id, provider):
        userDefault.socialID = id
        userDefault.socialProvider = provider
        
        state.path.append(.termsScreen())
        return .none
        
      case .moveToSignUp:
//        state.path.append(.signUpScreen())
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
  }
  
  public struct Path: Reducer {
    public enum State: Equatable {
      case termsScreen(TermsCore.State = .init())
      case signUpScreen(SignUpCore.State)
    }
    
    public enum Action: Equatable {
      case termsScreen(TermsCore.Action)
      case signUpScreen(SignUpCore.Action)
    }
    
    public var body: some ReducerOf<Self> {
      Scope(state: /State.termsScreen, action: /Action.termsScreen) {
        TermsCore()
      }
      
      Scope(state: /State.signUpScreen, action: /Action.signUpScreen) {
        SignUpCore()
      }
    }
  }
}
