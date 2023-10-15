import Foundation
import ComposableArchitecture

import Core

public struct OtherProfileCore: Reducer {

  public struct State: Equatable {
    @BindingState var isBlockSheetPresented: Bool = false

    var member: Member? = MemberResponse.mock.toDomain
    var votes: [Vote] = VoteListResponse.mock.votes.map(\.toDomain) + VoteListResponse.mock.votes.map(\.toDomain)

    public init() {}
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
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
