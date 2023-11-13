import Foundation
import ComposableArchitecture

import Core

public struct ProfileCore: Reducer {

  public enum Tab {
    case upload
    case evaluation
  }

  public struct State: Equatable {
    @BindingState var scrollViewOffset: CGPoint = .zero
    @BindingState var isHeaderFolded: Bool = false

    var path = StackState<Path.State>()
    var tab: Tab = .upload
    var member: Member?
    var votes: IdentifiedArrayOf<Vote> = []
    var evaluations: IdentifiedArrayOf<Vote> = []

    public init() {}
  }

  public enum Action: BindableAction {
    case uploadTabButtonTapped
    case evaluationTabButtonTapped
    case voteCellTapped(Vote)
    case voteEditButtonTapped

    case _onAppear
    case _onScrollViewAppear(Vote)
    case _fetchMyPageResponse(Member)
    case _fetchVotesResponse([Vote])
    case _fetchEvaluationsResponse([Vote])
    case _moveToSalMalDetail(Vote)
    case _scrollViewBottomReached

    case binding(BindingAction<State>)
    case path(StackAction<Path.State, Path.Action>)
  }

  @Dependency(\.toastManager) var toastManager
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.memberRepository) var memberRepository
  @Dependency(\.userDefault) var userDefault

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .uploadTabButtonTapped:
        state.tab = .upload
        return .run { send in
          let votes = try await memberRepository.votes(memberID: userDefault.memberID ?? -1, cursorId: nil, size: 100)
          await send(._fetchVotesResponse(votes))
        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case .evaluationTabButtonTapped:
        state.tab = .evaluation
        return .run { send in
          let evaluations = try await memberRepository.evaluations(cursorId: nil, size: 100)
          await send(._fetchEvaluationsResponse(evaluations))
        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case .voteCellTapped(let vote):
        return .run { send in
          let vote = try await voteRepository.getVote(id: vote.id)
          await send(._moveToSalMalDetail(vote))
        }

      case .voteEditButtonTapped:
        state.path.append(.uploadList())
        return .none

      case ._onAppear:
        return .merge(
          .run { send in
            let member = try await memberRepository.myPage()
            await send(._fetchMyPageResponse(member))
          } catch: { error, send in
            await toastManager.showToast(.error(error.localizedDescription))
          },
          .run { send in
            let votes = try await memberRepository.votes(memberID: userDefault.memberID!, cursorId: nil, size: 100)
            await send(._fetchVotesResponse(votes))
          } catch: { error, send in
            await toastManager.showToast(.error(error.localizedDescription))
          }
        )

      case ._onScrollViewAppear(let vote):
        return vote == state.votes.last ? .send(._scrollViewBottomReached) : .none

      case ._fetchMyPageResponse(let member):
        state.member = member
        return .none

      case ._fetchVotesResponse(let votes):
        state.votes = []
        state.votes.append(contentsOf: votes)
        return .none

      case ._fetchEvaluationsResponse(let evaluations):
        state.evaluations = []
        state.evaluations.append(contentsOf: evaluations)
        return .none
        
      case let ._moveToSalMalDetail(vote):
        state.path.append(.salmalDetail(.init(vote: vote)))
        return .none

      case ._scrollViewBottomReached:
        return .none

      case .binding(\.$scrollViewOffset):
        state.isHeaderFolded = -state.scrollViewOffset.y > 0
        return .none

      case .binding:
        return .none

      case let .path(.element(_, action: .salmalDetail(.delegate(.moveToOtherProfile(id))))):
        state.path.append(.otherProfile(.init(memberID: id)))
        return .none

      case .path:
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
      case otherProfile(OtherProfileCore.State)
      case profileEdit(ProfileEditCore.State = .init())
      case blockedMemberList(BlockedMemberListCore.State = .init())
      case setting(SettingCore.State = .init())
      case bookmarkList(BookmarkListCore.State = .init())
      case uploadList(UploadListCore.State = .init())
      case salmalDetail(SalMalDetailCore.State)
    }

    public enum Action {
      case otherProfile(OtherProfileCore.Action)
      case profileEdit(ProfileEditCore.Action)
      case blockedMemberList(BlockedMemberListCore.Action)
      case setting(SettingCore.Action)
      case bookmarkList(BookmarkListCore.Action)
      case uploadList(UploadListCore.Action)
      case salmalDetail(SalMalDetailCore.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: /State.otherProfile, action: /Action.otherProfile) {
        OtherProfileCore()
      }
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
