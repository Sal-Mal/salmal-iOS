import SwiftUI
import ComposableArchitecture

import UI

public struct BlockedMemberListView: View {

  private let store: StoreOf<BlockedMemberListCore>

  public init(store: StoreOf<BlockedMemberListCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        ZStack {
          if viewStore.blockedMemberList.isEmpty {
            VStack(spacing: 6) {
              Text("차단한 사용자가 없습니다.")
                .font(.ds(.title3(.semibold)))

              Text("혹시 마음에 들지 않는 사용자가 있나요?")
                .foregroundColor(.ds(.gray3))
                .font(.ds(.title4(.medium)))

              Spacer().frame(height: 100)
            }
            .frame(maxHeight: .infinity)

          } else {
            List(viewStore.blockedMemberList) { member in
              BlockedMemberListCell(member: member) {
                viewStore.send(.blockedMemberCellTapped(member))
              } buttonAction: {
                viewStore.send(.unblockButtonTapped(member))
              }
              .listRowInsets(.zero)
              .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
          }
        }
      }
      .smNavigationBar(title: "차단한 사용자", leftItems: {
        Button {
          viewStore.send(.backButtonTapped)
        } label: {
          Image(icon: .chevron_left)
        }
      })
      .onAppear {
        viewStore.send(._onAppear)
      }
      .navigationDestination(
        store: store.scope(state: \.$otherProfileState, action: { .otherProfileState($0) }),
        destination: OtherProfileView.init(store:)
      )
    }
  }
}

struct BlockedMemberListView_Previews: PreviewProvider {
  static var previews: some View {
    BlockedMemberListView(store: .init(initialState: .init(), reducer: {
      BlockedMemberListCore()._printChanges()
    }))
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
