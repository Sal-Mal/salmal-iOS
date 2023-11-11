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
      DragIndicator()
        .padding(.bottom, 23)
      
      ForEach(viewStore.items.indices, id: \.self) { index in
        MenuRow(item: viewStore.items[index])
          .onTapGesture {
            guard viewStore.isMyComment else {
              store.send(.report)
              return
            }

            if index == 0 {
              store.send(.edit)
            } else {
              store.send(.delete)
            }
          }
      }
    }
    .onAppear {
      BlurManager.shared.blurBackground()
    }
    .onDisappear {
      BlurManager.shared.clearBackground()
    }
  }
}

struct ReportCommentView_Previews: PreviewProvider {
  static var previews: some View {
    ReportCommentView(store: .init(initialState: .init(comment: CommentResponseDTO.mock.toDomain)) {
      ReportCommentCore()
    })
  }
}
