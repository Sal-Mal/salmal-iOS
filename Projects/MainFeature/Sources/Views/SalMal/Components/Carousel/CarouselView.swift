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
          }
        }
        .padding(600)
        .offset(y: yOffset)
        .animation(.easeInOut, value: yOffset)
        .gesture(dragGesture)
      }
      .padding(-600)
      .scrollDisabled(true)
      .clipped()
    }
    .task {
      store.send(._onAppear)
    }
    // 업로드 modal 닫힐때, homeList 업데이트 시켜주기
    .onReceive(NotificationService.publisher(.refreshSalMalList)) { _ in
      if viewStore.tab == .home {
        store.send(._onAppear)
      }
    }
  }
  
  var dragGesture: some Gesture {
    DragGesture(minimumDistance: 10)
      .updating($dragOffset) { value, state, _ in
        // 마지막 아이템인경우 하단 스크롤 막음
        if viewStore.index == viewStore.votes.count - 1 {
          return
        }
        
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
