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
      ForEach(viewStore.items.indices, id: \.self) { index in
        MenuRow(item: viewStore.items[index])
          .onTapGesture {
            store.send(.tap(index: index))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              dismiss()
            }
          }
      }
    }
    .padding(.top, 43)
  }
}

struct ReportView_Previews: PreviewProvider {
  static var previews: some View {
    ReportView(store: .init(initialState: ReportCore.State(voteID: .zero, memberID: .zero)) {
      ReportCore()
    })
  }
}

