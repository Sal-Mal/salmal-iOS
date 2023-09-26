import SwiftUI

import Core
import ComposableArchitecture

public struct CommentListView: View {
  let store: StoreOf<CommentListCore>
  @ObservedObject var viewStore: ViewStoreOf<CommentListCore>
  
  public init(store: StoreOf<CommentListCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    List {
      ForEachStore(store.scope(state: \.comments, action: CommentListCore.Action.comment(id:action:))) { subStore in
        CommentRow(store: subStore)
          .listRowSeparator(.hidden)
      }
    }
    .listStyle(.plain)
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
