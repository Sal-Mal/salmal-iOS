import SwiftUI
import ComposableArchitecture

import Core
import UI
import Kingfisher

struct BookmarkListView: View {
  
  private let store: StoreOf<BookmarkListCore>
  
  public init(store: StoreOf<BookmarkListCore>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        if viewStore.bookmarkedList.isEmpty {
          VStack(spacing: 6) {
            Text("북마크 내역이 없습니다.")
              .font(.ds(.title3(.semibold)))
            
            Text("새로운 투표를 북마크 해주세요.")
              .foregroundColor(.ds(.gray3))
              .font(.ds(.title4(.medium)))
          }
          .frame(maxHeight: .infinity)
        } else {
          ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [.init(), .init()], spacing: 8) {
              ForEach(viewStore.bookmarkedList) { bookmark in
                BookmarkCell(bookmark: bookmark)
                  .onTapGesture {
                    viewStore.send(.bookmarkTapped(bookmark))
                  }
              }
            }
          }
          .padding(18)
        }
      }
      .smNavigationBar(title: "북마크") {
        Button {
          viewStore.send(.dismissButtonTapped)
        } label: {
          Image(icon: .chevron_left)
        }
      } rightItems: {
      }
      .onAppear {
        viewStore.send(._onAppear)
        NotificationService.post(.hideTabBar)
      }
      .navigationDestination(
        store: store.scope(state: \.$salmalDetailState, action: { .salmalDetail($0) }),
        destination: SalMalDetailView.init(store:)
      )
    }
  }
  
  @ViewBuilder
  func BookmarkCell(bookmark: Vote) -> some View {
    KFImage(URL(string: bookmark.imageURL))
      .placeholder {
        RoundedRectangle(cornerRadius: 24.0)
          .fill(Color.ds(.gray2))
          .aspectRatio(1, contentMode: .fit)
      }
      .resizable()
      .aspectRatio(1, contentMode: .fit)
      .cornerRadius(24.0)
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
