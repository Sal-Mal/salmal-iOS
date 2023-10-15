import SwiftUI

import Core
import MainFeature
import ComposableArchitecture

struct ContentView: View {
  var body: some View {
    NavigationStack {
      SalMalView(store: .init(initialState: SalMalCore.State()) {
        SalMalCore()
          .dependency(\.network, MockNetworkManager())
      })
    }
    .preferredColorScheme(.dark)
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
