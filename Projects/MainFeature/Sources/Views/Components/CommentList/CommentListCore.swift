import ComposableArchitecture

public struct CommentListCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
  }
  
  public enum Action: Equatable {
    
  }
  
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
