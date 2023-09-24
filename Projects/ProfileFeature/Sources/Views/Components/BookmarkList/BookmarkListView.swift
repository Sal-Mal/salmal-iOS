import SwiftUI
import ComposableArchitecture

import Core
import UI

struct BookmarkListView: View {

  private let store: StoreOf<BookmarkListCore>

  public init(store: StoreOf<BookmarkListCore>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        LazyVGrid(columns: [.init(), .init()], spacing: 8) {
          ForEach(viewStore.bookmarkedList, id: \.id) { bookmark in
            AsyncImage(url: URL(string: bookmark.imageURL)) { phase in
              switch phase {
              case .success(let image):
                image
                  .resizable()
                  .aspectRatio(1, contentMode: .fit)
                  .cornerRadius(24.0)

              default:
                RoundedRectangle(cornerRadius: 24.0)
                  .fill(.gray)
              }
            }
          }
        }
      }
      .scrollIndicators(.hidden)
      .padding(18)
      .smNavigationBar(title: "북마크") {
        Button {
          viewStore.send(.dismissButtonTapped)
        } label: {
          Image(icon: .chevron_left)
        }
      } rightItems: {
      }
    }
  }
}

struct BookmarkListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      BookmarkListView(store: .init(initialState: .init(), reducer: {
        BookmarkListCore()
      }))
    }
    .preferredColorScheme(.dark)
  }
}
