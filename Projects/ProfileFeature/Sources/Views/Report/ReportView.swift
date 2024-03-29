import SwiftUI

import UI
import ComposableArchitecture

public struct ReportView: View {
  @Environment(\.dismiss) var dismiss
  
  let store: StoreOf<ReportCore>
  @ObservedObject var viewStore: ViewStoreOf<ReportCore>
  
  public init(store: StoreOf<ReportCore>) {
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
            store.send(.tap(index: index))
          }
      }
    }
    .alert(store: store.scope(state: \.$alert, action: { ._alert($0) }))
    .confirmationDialog(store: store.scope(state: \.$confirmDialog, action: { ._confirmDialog($0)}))
    .onAppear {
      BlurManager.shared.blurBackground()
    }
    .onDisappear {
      BlurManager.shared.clearBackground()
    }
  }
}

struct ReportView_Previews: PreviewProvider {
  static var previews: some View {
    ReportView(store: .init(initialState: ReportCore.State(voteID: .zero, memberID: .zero)) {
      ReportCore()
    })
  }
}

