import SwiftUI
import ComposableArchitecture

import Core
import UI

public struct SettingView: View {

  private let store: StoreOf<SettingCore>

  public init(store: StoreOf<SettingCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List(viewStore.menus) { menu in
        NavigationLink(state: menu.state) {
          HStack(spacing: 6) {
            Image(icon: menu.icon)
            Text(menu.title)
              .font(.ds(.title3(.medium)))
              .foregroundColor(.ds(.white))
          }
          .frame(height: 60)
        }
        .listRowInsets(.init(top: 0, leading: 18, bottom: 0, trailing: 18))
        .listRowSeparator(.hidden)
      }
      .listStyle(.plain)
      .onAppear {
        NotificationService.post(.hideTabBar)
      }
      .smNavigationBar(
        title: "설정",
        leftItems: {
          Button {
            viewStore.send(.backButtonTapped)
          } label: {
            Image(icon: .chevron_left)
              .foregroundColor(.ds(.white))
          }
        }
      )
    }
  }
}


struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SettingView(store: .init(initialState: .init(), reducer: {
        SettingCore()._printChanges()
      }))
      .preferredColorScheme(.dark)
      .onAppear {
        SM.Font.initFonts()
      }
    }
  }
}
