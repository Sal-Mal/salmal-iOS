import Foundation
import ComposableArchitecture

import Core

public struct BlockedMemberListCore: Reducer {
  
  public struct State: Equatable {
    var blockedMembers: IdentifiedArrayOf<Member> = []

    public init() {}
  }
  
  public enum Action {
    case onAppear
    case unblockButtonTapped(Member)
    case fetchBlockedMembers
    case setBlockedMembers([Member])
    case dismissButtonTapped
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.memberRepository) var memberRepository: MemberRepository
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.fetchBlockedMembers)

      case .unblockButtonTapped(let member):
        return .run { [id = member.id] send in
          try await memberRepository.unBlock(id: id)
          await send(.fetchBlockedMembers)

        } catch: { error, send in
          print(error)
        }

      case .fetchBlockedMembers:
        return .run { send in
          let memberPage = try await memberRepository.blocks(cursorId: 1, size: 10)
          await send(.setBlockedMembers(memberPage.members))
        } catch: { error, send in
          print(error)
        }

      case .setBlockedMembers(let members):
        state.blockedMembers.removeAll()
        state.blockedMembers.append(contentsOf: members)
        return .none

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }
      }
    }
  }
}
