import SwiftUI

import Core
import UI
import ComposableArchitecture

struct CommentCore: Reducer {
  struct State: Equatable {
    let comment: Comment
  }
  
  enum Action: Equatable {
    case moreCommentToggle
    case likeTapped
  }
  
  @Dependency(\.network) var network
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}

struct CommentRow: View {
  let store: StoreOf<CommentCore>
  @ObservedObject var viewStore: ViewStoreOf<CommentCore>
  
  init(store: StoreOf<CommentCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 13) {
      CacheAsyncImage(url: URL(string: "https://picsum.photos/100")!) { phase in
        switch phase {
        case let .success(image):
          image
            .fit(size: 32)
            .clipShape(Circle())
            
        default:
          Circle().fill(Color.ds(.gray1))
            .frame(width: 32)
        }
      }
      .debug()
      
      VStack(alignment: .leading, spacing: 9) {
        HStack(spacing: 8) {
          Text("username")
          Text("3시간 전")
        }
        Text("농부록 같아요...")
        HStack(spacing: .zero) {
          Text("100")
          Text("답글 달기")
        }
      }
      .debug()
    }
  }
}

struct CommentRow_Previews: PreviewProvider {
  static var previews: some View {
    CommentRow(store: .init(initialState: CommentCore.State(comment: CommentResponse.mock.toDomain)) {
      CommentCore()
    })
  }
}

