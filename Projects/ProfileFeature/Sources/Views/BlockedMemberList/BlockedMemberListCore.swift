import Foundation
import ComposableArchitecture

import Core

public struct BlockedMemberListCore: Reducer {
  
  public struct State: Equatable {
    @PresentationState var otherProfileState: OtherProfileCore.State?
    var blockedMemberList: IdentifiedArrayOf<Member> = []
    var cursorId: Int?
    var pagingSize: Int = 10
    var hasNext: Bool = false

    public init() {}
  }
  
  public enum Action {
    case backButtonTapped
    case blockedMemberCellTapped(Member)
    case unblockButtonTapped(Member)

    case _onAppear
    case _onScrollViewAppear
    case _fetchBlockedMemberList
    case _fetchBlockedMemberListResponse(MemberPage)

    case otherProfileState(PresentationAction<OtherProfileCore.Action>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.toastManager) var toastManager
  @Dependency(\.memberRepository) var memberRepository
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await dismiss()
        }

      case .blockedMemberCellTapped(let member):
        state.otherProfileState = .init(memberID: member.id)
        return .none

      case .unblockButtonTapped(let member):
        return .run { [id = member.id] send in
          try await memberRepository.unBlock(id: id)
          await send(._fetchBlockedMemberList)

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case ._onAppear:
        state.cursorId = nil
        return .send(._fetchBlockedMemberList)

      case ._onScrollViewAppear:
        guard state.hasNext else { return .none }
        return .send(._fetchBlockedMemberList)

      case ._fetchBlockedMemberList:
        return .run { [cursorId = state.cursorId, size = state.pagingSize] send in
          let memberPage = try await memberRepository.blocks(cursorId: cursorId, size: size)
          await send(._fetchBlockedMemberListResponse(memberPage))

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case ._fetchBlockedMemberListResponse(let page):
        state.blockedMemberList = []
        state.blockedMemberList.append(contentsOf: page.members)
        state.hasNext = page.hasNext
        state.cursorId = page.members.last?.id
        return .none

      case .otherProfileState:
        return .none
      }
    }
    .ifLet(\.$otherProfileState, action: /Action.otherProfileState) {
      OtherProfileCore()
    }
  }
}
