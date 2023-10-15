import Foundation
import ComposableArchitecture

import Core

public struct UploadListCore: Reducer {

  public struct State: Equatable {
    @BindingState var isDeletionPresented: Bool = false

    var votes: [Vote] = VoteListResponseDTO.mock.votes.map(\.toDomain)

    public init() {}
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case dismissButtonTapped
    case confirmButtonTapped
    case removeVoteTapped(Vote)
  }

  @Dependency(\.dismiss) var dismiss

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
      }
    }
  }
}
