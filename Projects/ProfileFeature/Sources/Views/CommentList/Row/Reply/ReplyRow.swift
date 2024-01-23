import SwiftUI

import Core
import UI
import ComposableArchitecture
import Kingfisher

struct ReplyCommentRow: View {
  let store: StoreOf<ReplyCommentCore>
  @ObservedObject var viewStore: ViewStoreOf<ReplyCommentCore>
  
  init(store: StoreOf<ReplyCommentCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 13) {
      KFImage(URL(string: viewStore.comment.memberImageUrl))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .frame(width: 32, height: 32)
        .clipShape(Circle())
      
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
            // MARK: - 더보기 버튼 탭
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
        }
      }
    }
  }
}

struct ReplyCommentRow_Previews: PreviewProvider {
  static var previews: some View {
    ReplyCommentRow(store: .init(initialState: ReplyCommentCore.State(comment: CommentResponseDTO.mock.toDomain)) {
      ReplyCommentCore()
    })
    .frame(maxWidth: .infinity, alignment: .leading)
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.dark)
  }
}

