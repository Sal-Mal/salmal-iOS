import SwiftUI
import ComposableArchitecture

public struct CarouselCore: Reducer {
  public struct State: Equatable {
    let spacing: CGFloat = 20
    var index = 0
    var votes: [Vote] = []
  }
  
  public enum Action: Equatable {
    case requestVoteList
    case updateIndex(y: CGFloat)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .requestVoteList:
        // TODO: - 5개 아이템 가져오기
        state.votes.append(contentsOf: [
          .dummy, .dummy, .dummy
        ])
        return .none
        
      case let .updateIndex(y):
        if y > 0 {
          state.index = max(0, state.index - 1)
        }
        
        if y < 0 {
          state.index = min(state.votes.count - 1, state.index + 1)
        }
        
        return .none
        
      default:
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
            SalMalContentView(store: Store(initialState: .init(vote: viewStore.votes[index])) {
              SalMalContentCore()
            }
            )
            .frame(width: width, height: height)
            .cornerRadius(24)
            .onAppear {
              
              // TODO: - Prefetching
              if index == viewStore.votes.count - 2 {
                print("\(index)")
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
      store.send(.requestVoteList)
    }
  }
  
  var dragGesture: some Gesture {
    DragGesture()
      .updating($dragOffset) { value, state, _ in
        state = value.translation.height
      }
      .onEnded { value in
        let y = value.translation.height
        store.send(.updateIndex(y: y))
      }
  }
}

struct CarouselView_Previews: PreviewProvider {
  static var previews: some View {
    CarouselView(store: .init(initialState: .init()) {
      CarouselCore()
        ._printChanges()
    })
    .padding(.horizontal, 20)
    .preferredColorScheme(.dark)
  }
}
