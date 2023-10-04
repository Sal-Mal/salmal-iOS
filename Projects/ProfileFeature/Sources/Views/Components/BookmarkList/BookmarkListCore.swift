import Foundation
import ComposableArchitecture

import Core

public struct BookmarkListCore: Reducer {

  public struct State: Equatable {

    var bookmarkedList: [Vote] = VoteListDTO.mock.votes.map(\.toDomain)

    public init() {}
  }

  public enum Action {
    case dismissButtonTapped
  }

  @Dependency(\.dismiss) var dismiss

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }
      }
    }
  }
}
