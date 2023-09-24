import SwiftUI
import ComposableArchitecture

import Core
import UI

public struct BlockedMemberListView: View {

  private let store: StoreOf<BlockedMemberListCore>

  public init(store: StoreOf<BlockedMemberListCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List(viewStore.blockedMembers) { member in
        BlockedMemberListCell(member: member) {
          viewStore.send(.unblockButtonTapped(member))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 16, leading: 18, bottom: 16, trailing: 18))
        .listRowSeparator(.hidden)
      }
      .listStyle(.plain)
      .smNavigationBar(
        title: "차단한 사용자",
        leftItems: {
          Button {
            viewStore.send(.dismissButtonTapped)
          } label: {
            Image(icon: .chevron_left)
          }
        }
      )
    }
  }
}

struct BlockedMemberListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      BlockedMemberListView(store: .init(initialState: .init(), reducer: {
        BlockedMemberListCore()._printChanges()
      }))
    }
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
