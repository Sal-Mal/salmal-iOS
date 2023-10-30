import Foundation
import ComposableArchitecture

import Core

public struct OtherProfileCore: Reducer {

  public struct State: Equatable {
    @BindingState var isBlockSheetPresented: Bool = false
    let memberID: Int

    var member: Member? = MemberResponseDTO.mock.toDomain
    var votes = [Vote]()

    public init(memberID: Int) {
      self.memberID = memberID
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case setMember(Member?)
    case setVote([Vote])
    case dismissButtonTapped
    case blockButtonTapped
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.memberRepository) var memberRepository: MemberRepository

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onAppear:
        return .run { [state] send in
          let member = try await memberRepository.member(id: state.memberID)
          let votes = try await memberRepository.votes(memberID: state.memberID, cursorId: nil, size: 20)
          print(votes)
          await send(.setMember(member))
          await send(.setVote(votes))
        } catch: { error, send in
          print(error)
        }
        
      case let .setMember(member):
        state.member = member
        return .none
        
      case let .setVote(vote):
        state.votes = vote
        return .none

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }

      case .blockButtonTapped:
        return .run { [state] send in
          try await memberRepository.block(id: state.memberID)
          await dismiss()
        } catch: { error, send in
          print(error.localizedDescription)
        }
      }
    }
  }
}
