import Foundation
import ComposableArchitecture

import Core

public struct BlockedMemberListCore: Reducer {
  
  public struct State: Equatable {
    var blockedMembers: IdentifiedArrayOf<Member> = [
      MemberDTO.mock.toDomain,
      MemberDTO.mock.toDomain,
      MemberDTO.mock.toDomain,
    ]

    public init() {}
  }
  
  public enum Action {
    case unblockButtonTapped(Member)
    case dismissButtonTapped
  }

  @Dependency(\.network) var network
  @Dependency(\.dismiss) var dismiss
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .unblockButtonTapped(let member):
        return .run { [id = member.id] send in
          try await network.request(MemberAPI.unBan(id: id))
          // TODO: 차단해제 후 Reload 작업

        } catch: { error, send in
          // TODO: 에러 처리
        }

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }
      }
    }
  }
}
