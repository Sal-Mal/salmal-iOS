import ComposableArchitecture

public struct TermDetailCore: Reducer {
  public struct State: Equatable {
    let url: String
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
