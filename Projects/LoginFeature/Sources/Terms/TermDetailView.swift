import SwiftUI

import ComposableArchitecture
import UI

struct TermDetailView: View {
  @Environment(\.dismiss) var dismiss
  
  let store: StoreOf<TermDetailCore>
  @ObservedObject var viewStore: ViewStoreOf<TermDetailCore>
  
  init(store: StoreOf<TermDetailCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }
  
  var body: some View {
    WebView(store: .init(initialState: .init(title: viewStore.title, urlString: viewStore.url)) {
      WebCore()
    })
  }
}

struct TermWebView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      TermDetailView(store: .init(initialState: .init(
        title: "이용약관",
        url: "https://www.naver.com")
      ) {
        TermDetailCore()
      })
        .preferredColorScheme(.dark)
    }
  }
}
