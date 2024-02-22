import Foundation
import ComposableArchitecture

import Core

public struct UploadListCore: Reducer {

  public struct State: Equatable {
    @BindingState var isDeletionPresented: Bool = false
    var targetVote: Vote?

    var votes: IdentifiedArrayOf<Vote> = []

    public init() {}
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case dismissButtonTapped
    case confirmButtonTapped
    case deleteButtonTapped
    case remoteButtonTapped(Vote)
    
    case _onAppear
    case _removeVoteResponse(TaskResult<Int>)

    case _setVotes([Vote])
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.memberRepository) var memberRepository
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.userDefault) var userDefault
  @Dependency(\.toastManager) var toastManager

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
        
      case let .remoteButtonTapped(vote):
        state.isDeletionPresented = true
        state.targetVote = vote
        return .none

      case .deleteButtonTapped:
        guard let id = state.targetVote?.id else { return .none }
        
        return .run { send in
          await send(._removeVoteResponse(
            TaskResult {
              try await voteRepository.delete(voteID: id)
              return id
            }
          ))
        }

      case ._onAppear:
        return .run { send in
          let votes = try await memberRepository.votes(memberID: userDefault.memberID ?? -1, cursorId: nil, size: 100)
          
          await send(._setVotes(votes))
        }

      case ._removeVoteResponse(.success(let id)):
        state.votes.removeAll(where: { $0.id == id })
        return .run { send in
          await toastManager.showToast(.success("투표를 삭제했어요."))
        }

      case ._removeVoteResponse(.failure):
        return .run { send in
          await toastManager.showToast(.warning("투표 삭제에 실패했어요."))
        }

      case ._setVotes(let votes):
        state.votes = []
        state.votes.append(contentsOf: votes)
        return .none
      }
    }
  }
}
