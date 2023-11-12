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
    
    case removeVote(id: Int)
    case removeAllVote(userID: Int)
    
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case updateVote(vote: Vote)
      case moveToprofile(id: Int)
    }
  }
  
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.memberRepository) var memberRepository
  
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
        return .send(.requestVoteList)
      
      case .requestVoteList:
        return .run { [state] send in
          
          let result: VoteList
          
          if state.tab == .home {
            result = try await voteRepository.homeList(
              size: Const.size,
              cursor: state.cursorID,
              cursorLikes: state.cursorLikes
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
          // TODO: Erorr 처리
          print(error)
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
        
      case let .removeVote(id):
        return .run { send in
          // 신고 요청
          try await voteRepository.report(voteID: id)
          // TODO: - ToastMessage를 띄운다
          // TODO: - 내가 보고있던 Votes를 없애버린다
        } catch: { error, send in
          // TODO: - ToastMessage를 띄운다
        }

      case let .removeAllVote(userID):
        return .run { send in
          // 차단 요청
          try await memberRepository.block(id: userID)
          // TODO: - ToastMessage를 띄운다
          // TODO: - 해당 유저의 게시물을 모두 지워버린다
        } catch: { error, send in
          // TODO: - ToastMessage를 띄운다
        }
      }
    }
    .forEach(\.votes, action: /Action.vote(id:action:)) {
      VoteItemCore()
    }
  }
}
