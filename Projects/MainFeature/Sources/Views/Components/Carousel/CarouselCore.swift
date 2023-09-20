import Foundation

import UI
import Core
import ComposableArchitecture

fileprivate enum Const {
  static let size = 20
}

public struct CarouselCore: Reducer {
  public struct State: Equatable {
    let tab: SMMainNavigationBar.Tab
    let spacing: CGFloat = 20
    var index = 0
    var votes: [Vote] = []
    var hasNext = false
  }
  
  public enum Action: Equatable {
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
          
          let result = try await networkManager.request(api, type: VoteListDTO.self)
          await send(.voteResponse(hasNext: result.hasNext, votes: result.votes.map { $0.toDomain }))
        } catch: { error, send in
          // TODO: Erorr 처리
        }
        
      case let .voteResponse(hasNext, votes):
        state.hasNext = hasNext
        state.votes.append(contentsOf: votes)
        
        /// 최초 로딩시 업데이트 시켜주기
        if state.index == 0 {
          return .send(.delegate(.updateVote(vote: state.votes[state.index])))
        }
        return .none
        
      case let .updateIndex(y):
        if y > 0 {
          state.index = max(0, state.index - 1)
        }
        
        if y < 0 {
          state.index = min(state.votes.count - 1, state.index + 1)
        }
        
        return .send(.delegate(.updateVote(vote: state.votes[state.index])))
        
      case let .removeVote(id):
        // TODO: 삭제 처리
//        print(state.votes.map { $0.id })
//        print(state.index)
//
//        if let index = state.votes.firstIndex (where: { $0.id == id}) {
//          state.votes.remove(at: index)
//        }
//
//        print(state.votes.map { $0.id })
//        print(state.index)
        
        return .none
        
      case let .removeAllVote(userID):
        // TODO: 해당 유저 차단
//        state.index = 0
//        state.votes.removeAll()
        
        return .none
      }
    }
  }
}
