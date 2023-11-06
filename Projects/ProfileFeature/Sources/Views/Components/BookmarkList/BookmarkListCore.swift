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

    case _onAppear

    case _setBookmarkList([Vote])
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

      case ._onAppear:
        return .run { send in
          let bookmarks = try await memberRepository.bookmarks(cursorId: nil, size: 100)
          await send(._setBookmarkList(bookmarks))

        } catch: { error, send in
          print(error)
        }

      case ._setBookmarkList(let votes):
        state.bookmarkedList.append(contentsOf: votes)
        return .none
      }
    }
  }
}
