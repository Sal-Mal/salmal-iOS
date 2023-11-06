import Foundation
import ComposableArchitecture

public struct PhotoAlbumCore: Reducer {

  public struct State: Equatable {}
  public enum Action {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      return .none
    }
  }
}
