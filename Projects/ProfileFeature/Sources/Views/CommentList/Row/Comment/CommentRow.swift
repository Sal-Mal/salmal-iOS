import SwiftUI

import Core
import UI
import ComposableArchitecture

struct CommentRow: View {
  let store: StoreOf<CommentCore>
  @ObservedObject var viewStore: ViewStoreOf<CommentCore>
  
  @State var modalHeight: CGFloat = .zero
  
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
            .fill(size: 32)
            .clipShape(Circle())
          
        default:
          Circle().fill(Color.ds(.gray1))
            .frame(width: 32)
        }
      }
      
      VStack(alignment: .leading, spacing: 9) {
        HStack(spacing: 8) {
          Text(viewStore.comment.nickName)
            .font(.ds(.title4(.semibold)))
            .foregroundColor(.ds(.white))
          
          Text(viewStore.timeDifference)
            .font(.ds(.title4(.medium)))
            .foregroundColor(.ds(.gray2))
          
          Spacer()
          
          Button {
            store.send(.optionsTapped)
          } label: {
            Image(icon: .ic_more)
              .fit(size: 24)
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
            .monospacedDigit()
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
        
        if let replyCount = viewStore.comment.replyCount,
           replyCount != .zero {
          Button {
            store.send(.moreCommentToggle)
          } label: {
            Text("답글 \(replyCount)개 보기")
              .font(.ds(.title4(.semibold)))
              .foregroundColor(.ds(.green1))
          }
          .padding(.top, 5)
          
          if viewStore.showMoreComment {
            ForEachStore(store.scope(state: \.replys, action: CommentCore.Action.replyComment(id: action:))) { store in
              ReplyCommentRow(store: store)
            }
          }
        }
      }
    }
    .background(Color.ds(.gray4))
    .sheet(store: store.scope(state: \.$report, action: CommentCore.Action.report)) { subStore in
      ReportCommentView(store: subStore)
        .readHeight()
        .onPreferenceChange(HeightPreferenceKey.self) { height in
          if let height {
            self.modalHeight = height
          }
        }
        .presentationDetents([.height(self.modalHeight)])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ds(.gray4))
    }
  }
}

struct CommentRow_Previews: PreviewProvider {
  static var previews: some View {
    CommentRow(store: .init(initialState: CommentCore.State(comment: CommentResponseDTO.mock.toDomain)) {
      CommentCore()
    })
    .frame(maxWidth: .infinity, alignment: .leading)
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.dark)
  }
}

