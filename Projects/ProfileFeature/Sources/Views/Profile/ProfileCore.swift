import Foundation
import ComposableArchitecture

import Core

public struct ProfileCore: Reducer {

  public enum Tab {
    case uploads
    case votes
  }

  public struct State: Equatable {
    var path = StackState<Path.State>()

    var tab: Tab = .uploads
    var member: Member? = MemberResponse.mock.toDomain
    var votes: [Vote] = VoteListDTO.mock.votes.map(\.toDomain) + VoteListDTO.mock.votes.map(\.toDomain)
    var evaluations: [Vote] = VoteListDTO.mock.votes.map(\.toDomain) + VoteListDTO.mock.votes.map(\.toDomain)

    public init() {}
  }

  public enum Action {
    case path(StackAction<Path.State, Path.Action>)
    case setTab(Tab)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .path:
        return .none

      case .setTab(let tab):
        state.tab = tab
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
  }
}


// MARK: - Extension

extension ProfileCore {

  public struct Path: Reducer {

    public enum State: Equatable {
      case profileEdit(ProfileEditCore.State = .init())
      case blockedMemberList(BlockedMemberListCore.State = .init())
      case setting(SettingCore.State = .init())
      case bookmarkList(BookmarkListCore.State = .init())
      case uploadList(UploadListCore.State = .init())
    }

    public enum Action {
      case profileEdit(ProfileEditCore.Action)
      case blockedMemberList(BlockedMemberListCore.Action)
      case setting(SettingCore.Action)
      case bookmarkList(BookmarkListCore.Action)
      case uploadList(UploadListCore.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: /State.profileEdit, action: /Action.profileEdit) {
        ProfileEditCore()
      }
      Scope(state: /State.blockedMemberList, action: /Action.blockedMemberList) {
        BlockedMemberListCore()
      }
      Scope(state: /State.setting, action: /Action.setting) {
        SettingCore()
      }
      Scope(state: /State.bookmarkList, action: /Action.bookmarkList) {
        BookmarkListCore()
      }
      Scope(state: /State.uploadList, action: /Action.uploadList) {
        UploadListCore()
      }
    }
  }

}
