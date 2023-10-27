import SwiftUI

import UI
import Core
import ComposableArchitecture

public struct CommentListView: View {
  let store: StoreOf<CommentListCore>
  @ObservedObject var viewStore: ViewStoreOf<CommentListCore>
  
  @Environment(\.dismiss) var dismiss
  
  public init(store: StoreOf<CommentListCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      CommentHeader
        .padding(.top, 30)
      
      Divider()
        .foregroundColor(.ds(.white20))
        .padding(.top, 13)
      
      CommentList
        .onTapGesture {
          UIApplication.shared.endEditing()
        }
      
      Divider()
        .frame(height: 2)
        .foregroundColor(.ds(.white20))
      
      CommentTextField
        .padding(18)
    }
    .onAppear {
      store.send(.requestComments)
      store.send(.requestMyPage)
    }
  }
}

private extension CommentListView {
  var CommentHeader: some View {
    HStack(spacing: 8) {
      Text("댓글")
        .font(.ds(.title2(.semibold)))
        .foregroundColor(.ds(.white))
        .padding(.leading, 20)
      
      Text("\(viewStore.commentCount)")
        .font(.ds(.title5))
        .foregroundColor(.ds(.gray2))
      
      Spacer()
      
      Button {
        dismiss()
      } label: {
        Image(icon: .xmark)
          .fit(size: 32)
      }
      .padding(.trailing, 16)
    }
  }
  
  @ViewBuilder
  var CommentList: some View {
    if viewStore.commentCount == 0 {
      Text("아직 댓글이 없네요\n첫 댓글을 작성해보세요 :)")
        .multilineTextAlignment(.center)
        .font(.ds(.title4(.medium)))
        .foregroundColor(.ds(.gray2))
        .frame(maxHeight: .infinity)
    } else {
      List {
        ForEachStore(store.scope(
          state: \.comments,
          action: CommentListCore.Action.comment(id:action:))
        ) { subStore in
          CommentRow(store: subStore)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.ds(.gray4))
        }
      }
      .listStyle(.plain)
      .buttonStyle(.plain)
    }
  }
  
  var CommentTextField: some View {
    SMCapsuleTextField(text: viewStore.$text, placeholder: "눌러서 댓글 입력")
      .leftImage(viewStore.profileImageURL)
      .rightButton("확인") {
        store.send(.tapConfirmButton)
      }
      .lineLimit(3)
  }
}

struct CommentListView_Previews: PreviewProvider {
  static var previews: some View {
    CommentListView(store: .init(initialState: .init(voteID: 0, commentCount: 20)) {
      CommentListCore()
    })
    .preferredColorScheme(.dark)
  }
}
