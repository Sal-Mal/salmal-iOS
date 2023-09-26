import SwiftUI

import SwiftUI
import ComposableArchitecture

struct CommentCore: Reducer {
  struct State: Equatable {
    
  }
  
  enum Action: Equatable {
    
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      return .none
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
    Text("")
  }
}

struct CommentRow_Previews: PreviewProvider {
  static var previews: some View {
    CommentRow(store: .init(initialState: CommentCore.State()) {
      CommentCore()
    })
  }
}

