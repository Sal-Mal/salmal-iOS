import SwiftUI

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
      case updateVote(total: Int, buy: Int, notBuy: Int)
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
          await send(.voteResponse(hasNext: result.hasNext, votes: result.votes.map { $0.toDomian }))
        } catch: { error, send in
          // TODO: Erorr 처리
        }
        
      case let .voteResponse(hasNext, votes):
        state.hasNext = hasNext
        state.votes.append(contentsOf: votes)
        
        /// 최초 로딩시 업데이트 시켜주기
        if state.index == 0 {
          let item = state.votes[state.index]
          return .send(.delegate(.updateVote(
            total: item.totalVoteCount,
            buy: item.likeCount,
            notBuy: item.disLikeCount
          )))
        }
        return .none
        
      case let .updateIndex(y):
        if y > 0 {
          state.index = max(0, state.index - 1)
        }
        
        if y < 0 {
          state.index = min(state.votes.count - 1, state.index + 1)
        }
        
        let item = state.votes[state.index]
        return .send(.delegate(.updateVote(total: item.totalVoteCount, buy: item.likeCount, notBuy: item.disLikeCount)))
        
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

public struct CarouselView: View {
  let store: StoreOf<CarouselCore>
  @ObservedObject var viewStore: ViewStoreOf<CarouselCore>
  
  public init(store: StoreOf<CarouselCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: {$0})
  }
  
  @GestureState var dragOffset: CGFloat = .zero
  
  public var body: some View {
    GeometryReader { proxy in
      let width = proxy.size.width
      let height = proxy.size.height
      
      let yOffset = CGFloat(viewStore.index) * -height + dragOffset + CGFloat(viewStore.index) * -viewStore.spacing
      
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(spacing: viewStore.spacing) {
          ForEach(viewStore.votes.indices, id: \.self) { index in
            let visibleIndices = [viewStore.index, viewStore.index + 1]
            
            SalMalContentView(store: Store(initialState: .init(vote: viewStore.votes[index])) {
              SalMalContentCore()
            })
            .frame(width: width, height: height)
            .cornerRadius(24)
            .opacity(visibleIndices.contains(index) ? 1 : 0)
            .onAppear {
              if viewStore.index == viewStore.votes.count - 3 {
                  store.send(.requestVoteList)
              }
            }
          }
        }
        .padding(height)
        .offset(y: yOffset)
        .animation(.spring(), value: yOffset)
        .gesture(dragGesture)
      }
      .scrollDisabled(true)
      .padding(-height)
      .clipped()
    }
    .task {
      // TODO: 무지성 로딩이아니라, 이전 커서를 유지해야함
      store.send(.requestVoteList)
    }
    .onReceive(NotiManager.publisher(.reportVote)) { userInfo in
      guard let id = userInfo["id"] as? Int else { return }
      store.send(.removeVote(id: id))
    }
    .onReceive(NotiManager.publisher(.banUser)) { userInfo in
      guard let id = userInfo["id"] as? Int else { return }
      store.send(.removeAllVote(userID: id))
    }
  }
  
  var dragGesture: some Gesture {
    DragGesture(minimumDistance: 10)
      .updating($dragOffset) { value, state, _ in
        state = value.translation.height
      }
      .onEnded { value in
        let y = value.translation.height
        guard abs(y) >= 30 else { return }
        
        store.send(.updateIndex(y: y))
      }
  }
}

struct CarouselView_Previews: PreviewProvider {
  static var previews: some View {
    CarouselView(store: .init(initialState: .init(tab: .home)) {
      CarouselCore()
        ._printChanges()
    })
    .padding(.horizontal, 20)
    .preferredColorScheme(.dark)
  }
}
