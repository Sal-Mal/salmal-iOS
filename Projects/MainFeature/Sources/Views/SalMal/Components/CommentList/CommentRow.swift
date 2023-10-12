import SwiftUI

import Core
import UI
import ComposableArchitecture

public struct CommentCore: Reducer {
  public struct State: Equatable, Identifiable {
    var comment: Comment
    var replys: IdentifiedArrayOf<ReplyCommentCore.State>
    
    var showMoreComment = false
    
    public init(comment: Comment) {
      self.comment = comment
      self.replys = []
    }
    
    public var id: Int {
      return comment.id
    }
  }
  
  public enum Action: Equatable {
    case replayComment(id: ReplyCommentCore.State.ID, action: ReplyCommentCore.Action)
    case moreCommentToggle
    case writeCommentToggle
    case likeTapped
  }
  
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .moreCommentToggle:
        state.showMoreComment.toggle()
        return .none
        
      case .likeTapped:
        state.comment.liked.toggle()
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.replys, action: /Action.replayComment(id:action:)) {
      ReplyCommentCore()
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
          
          Spacer()
          
          Button {
            // MARK: - 더보기 버튼 탭
          } label: {
            Image(systemName: "poweron")
              .fit(size: 16)
          }
          .padding(.trailing, 10)
        }
        
        Text(viewStore.comment.content)
          .font(.ds(.title4(.medium)))
          .foregroundColor(.ds(.white))
        
        HStack(spacing: .zero) {
          Button {
            store.send(.likeTapped)
          } label: {
            Image(systemName: viewStore.comment.liked ? "heart.fill" : "heart")
              .fit(size: 14, renderingMode: .template)
              .tint(.ds(.white))
          }
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
        
//        if let replys = viewStore.comment.replys, replys.isEmpty == false {
//          Button {
//            store.send(.moreCommentToggle)
//          } label: {
//            Text("답글 \(replys.count)개 보기")
//              .font(.ds(.title4(.semibold)))
//              .foregroundColor(.ds(.green1))
//
//          }
//          .padding(.top, 5)
//
//          if viewStore.showMoreComment {
//            ForEach(replys) { reply in
//              ReplyCommentRow(store: .init(initialState: .init(comment: reply)) {
//                ReplyCommentCore()
//              })
//              .frame(height: 101)
//              .debug()
//            }
//            .buttonStyle(.plain)
//          }
//        }
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

