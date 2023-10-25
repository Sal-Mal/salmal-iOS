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
      .padding(.top, 30)
      
      Divider()
        .foregroundColor(.ds(.white20))
        .padding(.top, 13)
      
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
      .onTapGesture {
        UIApplication.shared.endEditing()
      }
      
      Divider()
        .frame(height: 2)
        .foregroundColor(.ds(.white20))
      
      SMCapsuleTextField(text: viewStore.$text, placeholder: "눌러서 댓글 입력")
        .leftImage(viewStore.profileImageURL)
        .rightButton("확인") {
          store.send(.tapConfirmButton)
        }
        .lineLimit(3)
        .padding(18)
    }
    .onAppear {
      store.send(.requestComments)
      store.send(.requestMyPage)
    }
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
