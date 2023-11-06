import Foundation
import ComposableArchitecture

import Core

public struct UploadListCore: Reducer {

  public struct State: Equatable {
    @BindingState var isDeletionPresented: Bool = false

    var votes: IdentifiedArrayOf<Vote> = []

    public init() {}
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case dismissButtonTapped
    case confirmButtonTapped
    case removeVoteTapped(Vote)

    case _onAppear

    case _setVotes([Vote])
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.memberRepository) var memberRepository: MemberRepository
  @Dependency(\.userDefault) var userDefault

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }

      case .confirmButtonTapped:
        return .none

      case .removeVoteTapped(let vote):
        state.votes.removeAll(where: { $0.id == vote.id })
        return .none

      case ._onAppear:
        return .run { send in
          let votes = try await memberRepository.votes(memberID: userDefault.memberID!, cursorId: nil, size: 100)
          await send(._setVotes(votes))
        }

      case ._setVotes(let votes):
        state.votes.append(contentsOf: votes)
        return .none
      }
    }
  }
}
