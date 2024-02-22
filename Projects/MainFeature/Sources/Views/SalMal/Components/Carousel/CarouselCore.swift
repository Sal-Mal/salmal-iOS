import Foundation

import UI
import Core
import ComposableArchitecture
import Alamofire

fileprivate enum Const {
  static let size = 5
}

public struct CarouselCore: Reducer {
  public struct State: Equatable {
    let tab: SMMainNavigationBar.Tab
    let spacing: CGFloat = 20
    var index = 0
    var votes: IdentifiedArrayOf<VoteItemCore.State> = []
    var hasNext = false
    var cursorLikes: Int?
    var cursorID: Int?
  }
  
  public enum Action: Equatable {
    
    case vote(id: VoteItemCore.State.ID, action: VoteItemCore.Action)
    
    // MARK: - User Action
    
    // MARK: - Internal Action
    case _onAppear
    
    case requestVoteList
    case updateIndex(y: CGFloat)
    case voteResponse(VoteList)
    
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case updateVote(vote: Vote)
      case moveToprofile(id: Int)
    }
  }
  
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.memberRepository) var memberRepository
  @Dependency(\.toastManager) var toastManager
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let .vote(id, .delegate(.updateVote(vote))):
        state.votes[id: id] = .init(vote: vote)
        return .none
        
      case let .vote(_, .delegate(.moveToProfile(id))):
        return .send(.delegate(.moveToprofile(id: id)))
        
      case .vote:
        return .none
        
      case .delegate:
        return .none
        
      case ._onAppear:
        state = .init(tab: state.tab)
        state.votes = []
        return .send(.requestVoteList)
        
      case .requestVoteList:
        return .run { [state] send in
          
          let result: VoteList
          
          if state.tab == .home {
            result = try await voteRepository.homeList(
              size: Const.size,
              cursor: state.cursorID
            )
          } else {
            result = try await voteRepository.bestList(
              size: Const.size,
              cursor: state.cursorID,
              cursorLikes: state.cursorLikes
            )
          }
          
          await send(.voteResponse(result))
        } catch: { error, send in
          await toastManager.showToast(.error("투표 리스트 조회에 실패했어요"))
        }
        
      case let .voteResponse(result):
        state.hasNext = result.hasNext
        state.cursorID = result.votes.last?.id
        state.cursorLikes = result.votes.last?.likeCount
        
        let newItems = result.votes.map { VoteItemCore.State(vote: $0) }
        state.votes.append(contentsOf: newItems)
        
        /// 최초 로딩시 업데이트 시켜주기
        if state.index == 0 && state.votes.isEmpty == false {
          let item = state.votes[state.index].vote
          return .send(.delegate(.updateVote(vote: item)))
        }
        return .none
        
      case let .updateIndex(y):
        let startIndex = state.index
        
        if y > 0 {
          state.index = max(0, state.index - 1)
        }
        
        if y < 0 {
          state.index = min(state.votes.count - 1, state.index + 1)
        }
        
        /// Index의 변화가 없을 경우
        if startIndex == state.index { return .none }
        
        let item = state.votes[state.index].vote
        
        if state.index + 2 >= state.votes.count && state.hasNext {
          return .concatenate(
            .send(.requestVoteList),
            .send(.delegate(.updateVote(vote: item)))
          )
        } else {
          return .send(.delegate(.updateVote(vote: item)))
        }
      }
    }
    .forEach(\.votes, action: /Action.vote(id:action:)) {
      VoteItemCore()
    }
  }
}
