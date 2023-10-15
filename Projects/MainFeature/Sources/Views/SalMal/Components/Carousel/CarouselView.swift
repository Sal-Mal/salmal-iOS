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
        LazyVStack(spacing: 0) {
          ForEachStore(store.scope(state: \.votes, action: CarouselCore.Action.vote(id:action:))) { subStore in
            
            VoteItemView(store: subStore)
              .frame(width: width, height: height)
              .cornerRadius(24)
              .padding(.bottom, 20)
              .background(Color.ds(.black))
              .onAppear {
                subStore.send(.onAppear)
              }
              .onDisappear {
                subStore.send(.onDisappear)
              }
          }
        }
        .offset(y: yOffset)
        .animation(.easeInOut, value: yOffset)
        .gesture(dragGesture)
      }
      .scrollDisabled(true)
      .clipped()
    }
    .task {
      // TODO: 무지성 로딩이아니라, 이전 커서를 유지해야함
      store.send(.requestVoteList)
    }
    .onReceive(NotificationService.publisher(.reportVote)) { userInfo in
      guard let id = userInfo["id"] as? Int else { return }
      store.send(.removeVote(id: id))
    }
    .onReceive(NotificationService.publisher(.banUser)) { userInfo in
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
    })
    .padding(.horizontal, 20)
    .preferredColorScheme(.dark)
  }
}
