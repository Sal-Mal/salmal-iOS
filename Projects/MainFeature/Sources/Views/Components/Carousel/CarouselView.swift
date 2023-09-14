import SwiftUI
import UI
import Core
import ComposableArchitecture

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
