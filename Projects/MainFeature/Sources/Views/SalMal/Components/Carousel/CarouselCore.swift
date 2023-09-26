import Foundation

import UI
import Core
import ComposableArchitecture
import Alamofire

fileprivate enum Const {
  static let size = 20
}

public struct CarouselCore: Reducer {
  public struct State: Equatable {
    let tab: SMMainNavigationBar.Tab
    let spacing: CGFloat = 20
    var index = 0
    var votes: IdentifiedArrayOf<VoteItemCore.State> = []
    var hasNext = false
  }
  
  public enum Action: Equatable {
    case vote(id: VoteItemCore.State.ID, action: VoteItemCore.Action)
    case requestVoteList
    case updateIndex(y: CGFloat)
    case voteResponse(hasNext: Bool, votes: [Vote])
    
    case removeVote(id: Int)
    case removeAllVote(userID: Int)
    
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case updateVote(vote: Vote)
    }
  }
  
  @Dependency(\.network) var networkManager
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let .vote(id, action):
        return .none
        
      case .delegate:
        return .none
      
      case .requestVoteList:
        return .run { [state] send in
          
          let api: VoteAPI
          let cursor = state.votes.last?.id
          
          if state.tab == .home {
            api = .homeList(size: Const.size, cursor: cursor)
          } else {
            api = .bestList(size: Const.size, cursor: cursor)
          }
          
          let result = try await networkManager.request(api, type: VoteListResponse.self)
//          let result = try await networkManager.request(api)
          print(result)
//          await send(.voteResponse(hasNext: result.hasNext, votes: result.votes.map { $0.toDomain }))
        } catch: { error, send in
          // TODO: Erorr 처리
          print(error)
        }
        
      case let .voteResponse(hasNext, votes):
        state.hasNext = hasNext
        let newItems = votes.map { VoteItemCore.State(vote: $0) }
        state.votes.append(contentsOf: newItems)
        
        /// 최초 로딩시 업데이트 시켜주기
        if state.index == 0 {
          let item = state.votes[state.index].vote
          return .send(.delegate(.updateVote(vote: item)))
        }
        return .none
        
      case let .updateIndex(y):
        if y > 0 {
          state.index = max(0, state.index - 1)
        }
        
        if y < 0 {
          state.index = min(state.votes.count - 1, state.index + 1)
        }
        
        let item = state.votes[state.index].vote
        return .send(.delegate(.updateVote(vote: item)))
        
      case let .removeVote(id):
        return .run { send in
          // 신고 요청
          try await networkManager.request(VoteAPI.report(id: id))
          // TODO: - ToastMessage를 띄운다
          // TODO: - 내가 보고있던 Votes를 없애버린다
        } catch: { error, send in
          // TODO: - ToastMessage를 띄운다
        }

      case let .removeAllVote(userID):
        return .run { send in
          // 차단 요청
          try await networkManager.request(MemberAPI.ban(id: userID))
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
