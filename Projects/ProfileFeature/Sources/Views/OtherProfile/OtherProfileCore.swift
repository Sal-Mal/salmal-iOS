import Foundation
import ComposableArchitecture

import Core

public struct OtherProfileCore: Reducer {

  public struct State: Equatable {
    @BindingState var scrollViewOffset: CGPoint = .zero
    @BindingState var isBlockSheetPresented: Bool = false
    @BindingState var isHeaderFolded: Bool = false

    let memberId: Int
    var member: Member?
    var votes: IdentifiedArrayOf<Vote> = []

    var cursorId: Int?
    var pagingSize: Int = 10
    var hasNext: Bool = false

    public init(memberID: Int) {
      self.memberId = memberID
    }
  }

  public enum Action: BindableAction, Equatable {
    case backButtonTapped
    case blockButtonTapped
    case unBlockButtonTapped
    case blockSheetConfirmButtonTapped
    case voteCellTapped(Vote)
    
    case _onAppear
    case _onScrollViewAppear(Vote)
    case _fetchMemberResponse(Member)
    case _fetchVotesResponse([Vote])
    case _scrollViewBottomReached

    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case moveToSalMalDetail(Vote)
    }
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.memberRepository) var memberRepository
  @Dependency(\.toastManager) var toastManager

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in await dismiss() }

      case .blockButtonTapped:
        state.isBlockSheetPresented = true
        return .none

      case .unBlockButtonTapped:
        return .run { [id = state.memberId] send in
          try await memberRepository.unBlock(id: id)

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case .blockSheetConfirmButtonTapped:
        return .run { [state] send in
          try await memberRepository.block(id: state.memberId)
          await dismiss()

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case .voteCellTapped(let vote):
        return .run { [id = vote.id] send in
          let vote = try await voteRepository.getVote(id: id)
          await send(.delegate(.moveToSalMalDetail(vote)))

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case ._onAppear:
        return .merge(
          .run { [memberId = state.memberId] send in
            let member = try await memberRepository.member(id: memberId)
            await send(._fetchMemberResponse(member))

          } catch: { error, send in
            await toastManager.showToast(.error(error.localizedDescription))
          },
          .run { [memberId = state.memberId, cursorId = state.cursorId, size = state.pagingSize] send in
            let votes = try await memberRepository.votes(memberID: memberId, cursorId: cursorId, size: size)
            await send(._fetchVotesResponse(votes))

          } catch: { error, send in
            await toastManager.showToast(.error(error.localizedDescription))
          }
        )

      case ._onScrollViewAppear(let vote):
        return vote == state.votes.last ? .send(._scrollViewBottomReached) : .none

      case ._fetchMemberResponse(let member):
        state.member = member
        return .none

      case ._fetchVotesResponse(let votes):
        state.votes = []
        state.votes.append(contentsOf: votes)
        state.cursorId = votes.last?.id
        return .none

      case ._scrollViewBottomReached:
        return .run { [memberId = state.memberId, cursorId = state.cursorId, size = state.pagingSize] send in
          let votes = try await memberRepository.votes(memberID: memberId, cursorId: cursorId, size: size)
          await send(._fetchVotesResponse(votes))

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case .binding(\.$scrollViewOffset):
        state.isHeaderFolded = -state.scrollViewOffset.y > 0
        return .none

      case .binding:
        return .none

      case .delegate:
        return .none
      }
    }
  }
}
