import ComposableArchitecture

public struct LoginCore: Reducer {
  public struct State: Equatable {
    
  }
  
  public enum Action: Equatable {
    
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
