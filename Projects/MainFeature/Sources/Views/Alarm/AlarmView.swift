import SwiftUI
import ComposableArchitecture

public struct AlarmCore: Reducer {
  public struct State: Equatable {
    public init() {
      
    }
  }
  
  public enum Action: Equatable {
    case listTapped
  }
  
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .listTapped:
        return .none
      }
    }
  }
}

struct AlarmView: View {
  let store: StoreOf<AlarmCore>
  @ObservedObject var viewStore: ViewStoreOf<AlarmCore>
  @Environment(\.dismiss) var dismiss
  
  init(store: StoreOf<AlarmCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }
  
  var body: some View {
    List {
      AlarmRow()
        .listRowSeparator(.hidden)
      AlarmRow()
        .listRowSeparator(.hidden)
      AlarmRow()
        .listRowSeparator(.hidden)
      AlarmRow()
        .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
    .smNavigationBar(title: "알림", leftItems: {
      Image(icon: .chevron_left)
        .fit(size: 32)
        .onTapGesture {
          dismiss()
        }
    })
  }
}

struct AlarmView_Preview: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AlarmView(store: .init(initialState: .init()) {
        AlarmCore()
      })
    }
    .preferredColorScheme(.dark)
  }
}
