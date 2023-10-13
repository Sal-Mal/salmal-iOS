import SwiftUI

import UI
import Core
import ComposableArchitecture

public struct ReportCommentView: View {
  let store: StoreOf<ReportCommentCore>
  @ObservedObject var viewStore: ViewStoreOf<ReportCommentCore>
  
  public init(store: StoreOf<ReportCommentCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      ForEach(viewStore.items.indices, id: \.self) { index in
        MenuRow(item: viewStore.items[index])
          .onTapGesture {
            switch index {
            case 0:
              store.send(.edit)
            case 1:
              store.send(.delete)
            case 2:
              store.send(.report)
            default:
              break
            }
          }
      }
    }
    .padding(.top, 43)
  }
}

struct ReportCommentView_Previews: PreviewProvider {
  static var previews: some View {
    ReportCommentView(store: .init(initialState: .init(commentID: 2)) {
      ReportCommentCore()
    })
  }
}
