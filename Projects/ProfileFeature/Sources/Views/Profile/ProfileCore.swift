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
    var member: Member?
    var votes: IdentifiedArrayOf<Vote> = []
    var evaluations: IdentifiedArrayOf<Vote> = []

    public init() {}
  }

  public enum Action {
    case onAppear
    case path(StackAction<Path.State, Path.Action>)
    case setTab(Tab)
    case setMember(Member?)
    case setVotes([Vote])
    case setEvaluations([Vote])
    
    case requestVote(Int)
    case moveToSalMalDetail(Vote)
  }

  @Dependency(\.voteRepository) var voteRepository: VoteRepository
  @Dependency(\.memberRepository) var memberRepository: MemberRepository
  @Dependency(\.userDefault) var userDefault

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let member = try await memberRepository.myPage()
          let votes = try await memberRepository.votes(memberID: userDefault.memberID!, cursorId: nil, size: 100)
          await send(.setMember(member))
          await send(.setVotes(votes))

        } catch: { error, send in
          print(error)
        }

      case .path:
        return .none

      case .setTab(let tab):
        state.tab = tab
        return .none

      case .setMember(let member):
        state.member = member
        return .none

      case .setVotes(let votes):
        state.votes.append(contentsOf: votes)
        return .none

      case .setEvaluations(let evaluations):
        state.evaluations.append(contentsOf: evaluations)
        return .none
        
      case let .requestVote(id):
        return .run { send in
          let vote = try await voteRepository.getVote(id: id)
          await send(.moveToSalMalDetail(vote))
        }
        
      case let .moveToSalMalDetail(vote):
        state.path.append(.salmalDetail(.init(vote: vote)))
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
      case salmalDetail(SalMalDetailCore.State)
    }

    public enum Action {
      case profileEdit(ProfileEditCore.Action)
      case blockedMemberList(BlockedMemberListCore.Action)
      case setting(SettingCore.Action)
      case bookmarkList(BookmarkListCore.Action)
      case uploadList(UploadListCore.Action)
      case salmalDetail(SalMalDetailCore.Action)
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
      Scope(state: /State.salmalDetail, action: /Action.salmalDetail) {
        SalMalDetailCore()
      }
    }
  }

}
