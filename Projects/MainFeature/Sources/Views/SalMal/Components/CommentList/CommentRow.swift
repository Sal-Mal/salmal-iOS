import SwiftUI

import Core
import UI
import ComposableArchitecture

public struct CommentCore: Reducer {
  public struct State: Equatable, Identifiable {
    let comment: Comment
    
    public var id: Int {
      return comment.id
    }
  }
  
  public enum Action: Equatable {
    case moreCommentToggle
    case writeCommentToggle
    case likeTapped
  }
  
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
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
      CacheAsyncImage(url: URL(string: viewStore.comment.memberImageUrl)!) { phase in
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
      
      VStack(alignment: .leading, spacing: 9) {
        HStack(spacing: 8) {
          Text("username")
            .font(.ds(.title4(.semibold)))
            .foregroundColor(.ds(.white))
          
          Text("3시간 전")
            .font(.ds(.title4(.medium)))
            .foregroundColor(.ds(.gray2))
          
        }
        
        Text(viewStore.comment.content)
          .font(.ds(.title4(.medium)))
          .foregroundColor(.ds(.white))
        
        HStack(spacing: .zero) {
          Image(systemName: viewStore.comment.liked ? "heart.fill" : "heart")
            .fit(size: 14, renderingMode: .template)
            .tint(.ds(.white))
            .padding(.trailing, 5)
          
          Text("\(viewStore.comment.likeCount)")
            .padding(.trailing, 16)
          
          Button {
            // TODO: 답글달기 눌렀을때
            store.send(.writeCommentToggle)
          } label: {
            Text("답글 달기")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.gray2))
          }
        }
      }
    }
  }
}

struct CommentRow_Previews: PreviewProvider {
  static var previews: some View {
    CommentRow(store: .init(initialState: CommentCore.State(comment: CommentResponse.mock.toDomain)) {
      CommentCore()
    })
    .frame(maxWidth: .infinity, alignment: .leading)
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.dark)
  }
}

