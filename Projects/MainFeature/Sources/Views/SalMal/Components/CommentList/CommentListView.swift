import SwiftUI

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
        
        Text("365")
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
        ForEachStore(store.scope(state: \.comments, action: CommentListCore.Action.comment(id:action:))) { subStore in
          Section {
            CommentRow(store: subStore)
              .listRowSeparator(.hidden)
            
            ForEachStore(subStore.scope(state: \.replys, action: CommentCore.Action.replayComment(id:action:))) { subStore in
              ReplyCommentRow(store: subStore)
                .listRowSeparator(.hidden)
            }
            .padding(.leading, 62)
          }
        }
        .onDelete {
          print($0.first!)
        }
      }
      .listStyle(.plain)
      .buttonStyle(.plain)
    }
    .onAppear {
      store.send(.requestComments)
    }
  }
}

struct CommentListView_Previews: PreviewProvider {
  static var previews: some View {
    CommentListView(store: .init(initialState: .init(voteID: 0)) {
      CommentListCore()
    })
    .preferredColorScheme(.dark)
  }
}
