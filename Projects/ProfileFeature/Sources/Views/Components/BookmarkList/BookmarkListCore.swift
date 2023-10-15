import Foundation
import ComposableArchitecture

import Core

public struct BookmarkListCore: Reducer {

  public struct State: Equatable {
    var bookmarkedList: IdentifiedArrayOf<Vote> = []

    public init() {}
  }

  public enum Action {
    case bookmarkTapped(Vote)
    case dismissButtonTapped
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.memberRepository) var memberRepository: MemberRepository

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .bookmarkTapped(let vote):
        print(vote)
        return .none

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }
      }
    }
  }
}
