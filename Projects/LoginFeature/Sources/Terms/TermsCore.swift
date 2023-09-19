import ComposableArchitecture

public struct TermsCore: Reducer {
  public struct State: Equatable {
    var all = false
    @BindingState var termsOfUse = false
    @BindingState var personalInformation = false
    @BindingState var marketing = false

    var nextButtonState: Bool {
      return all || termsOfUse && personalInformation
    }
    
    public init() {}
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case toggleAll
  }
  
  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .toggleAll:
        state.all.toggle()
        
        state.termsOfUse = state.all
        state.personalInformation = state.all
        state.marketing = state.all
        return .none

      default:
        return .none
      }
    }
  }
}
