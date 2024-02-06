import SwiftUI
import Core
import ComposableArchitecture

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
      ForEach(viewStore.alarms) { alarm in
        AlarmRow(alarm: alarm)
          .listRowSeparator(.hidden)
          .onTapGesture {
            store.send(.listTapped(alarm))
          }
      }
      .onDelete {
        store.send(.swipeDelete($0))
      }
    }
    .listStyle(.plain)
    .task {
      NotificationService.post(.hideTabBar)
      store.send(._requestAlarmList)
      
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      store.send(._requestVote)
    }
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
