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
    WebView(urlString: viewStore.url)
      .smNavigationBar(title: "이용약관", leftItems: {
        Image(icon: .chevron_left)
          .fit(size: 32)
          .onTapGesture {
            dismiss()
          }
      })
  }
}

struct TermWebView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      TermDetailView(store: .init(initialState: .init(url: "https://www.naver.com")) {
        TermDetailCore()
      })
        .preferredColorScheme(.dark)
    }
  }
}
