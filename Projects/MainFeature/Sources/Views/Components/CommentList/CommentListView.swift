import SwiftUI

import ComposableArchitecture

public struct CommentListView: View {
  let store: StoreOf<CommentListCore>
  @ObservedObject var viewStore: ViewStoreOf<CommentListCore>
  
  public init(store: StoreOf<CommentListCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    Text("")
  }
}

struct CommentListView_Previews: PreviewProvider {
  static var previews: some View {
    CommentListView(store: .init(initialState: CommentListCore.State(voteID: 0)) {
      CommentListCore()
    })
  }
}
