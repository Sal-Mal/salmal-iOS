import Foundation
import ComposableArchitecture

import Core

public struct OtherProfileCore: Reducer {

  public struct State: Equatable {
    @BindingState var isBlockSheetPresented: Bool = false
    let memberID: Int

    var member: Member? = MemberResponseDTO.mock.toDomain
    var votes: [Vote] = VoteListResponseDTO.mock.votes.map(\.toDomain) + VoteListResponseDTO.mock.votes.map(\.toDomain)

    public init(memberID: Int) {
      self.memberID = memberID
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case setMember(Member?)
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
          await send(.setMember(member))
        } catch: { error, send in
          print(error)
        }
        
      case let .setMember(member):
        state.member = member
        return .none

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }

      case .blockButtonTapped:
        return .none
      }
    }
  }
}
