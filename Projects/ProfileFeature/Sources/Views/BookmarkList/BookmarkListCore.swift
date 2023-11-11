import Foundation
import ComposableArchitecture

import Core

public struct BookmarkListCore: Reducer {

  public struct State: Equatable {
    @PresentationState var salmalDetailState: SalMalDetailCore.State?
    var bookmarkedList: IdentifiedArrayOf<Vote> = []

    public init() {}
  }

  public enum Action {
    case bookmarkTapped(Vote)
    case dismissButtonTapped

    case _onAppear
    case _fetchVoteResponse(Vote)

    case _setBookmarkList([Vote])
    case salmalDetail(PresentationAction<SalMalDetailCore.Action>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.memberRepository) var memberRepository
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.toastManager) var toastManager

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .bookmarkTapped(let vote):
        return .run { [id = vote.id] send in
          let response = try await voteRepository.getVote(id: id)
          await send(._fetchVoteResponse(response))
        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }

      case ._onAppear:
        return .run { send in
          let bookmarks = try await memberRepository.bookmarks(cursorId: nil, size: 100)
          await send(._setBookmarkList(bookmarks))

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case ._fetchVoteResponse(let vote):
        state.salmalDetailState = .init(vote: vote)
        return .none

      case ._setBookmarkList(let votes):
        state.bookmarkedList = []
        state.bookmarkedList.append(contentsOf: votes)
        return .none

      case .salmalDetail:
        return .none
      }
    }
    .ifLet(\.$salmalDetailState, action: /Action.salmalDetail) {
      SalMalDetailCore()
    }
  }
}
