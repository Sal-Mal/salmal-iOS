import SwiftUI

import ComposableArchitecture

public struct WebView: View {
  let store: StoreOf<WebCore>
  @Environment(\.dismiss) var dismiss
  
  public init(store: StoreOf<WebCore>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      WebViewRepresentable(urlString: viewStore.urlString)
        .smNavigationBar(title: viewStore.title, leftItems: {
          Image(icon: .chevron_left)
            .fit(size: 32)
            .onTapGesture {
              dismiss()
            }
        })
    }
  }
}
