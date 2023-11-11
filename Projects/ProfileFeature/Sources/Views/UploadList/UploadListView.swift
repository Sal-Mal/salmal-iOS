import SwiftUI
import ComposableArchitecture

import UI

struct UploadListView: View {

  private let store: StoreOf<UploadListCore>

  public init(store: StoreOf<UploadListCore>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        LazyVGrid(columns: [.init(), .init()], spacing: 8) {
          ForEach(viewStore.votes, id: \.id) { vote in
            CacheAsyncImage(url: URL(string: vote.imageURL)!) { phase in
              switch phase {
              case .success(let image):
                image
                  .resizable()
                  .aspectRatio(1, contentMode: .fit)
                  .cornerRadius(24)
                  .overlay(alignment: .topTrailing) {
                    Button {
                      viewStore.send(.binding(.set(\.$isDeletionPresented, true)))
                    } label: {
                      Image(icon: .delete)
                        .padding(8)
                    }
                  }
                  .alert(isPresented: viewStore.$isDeletionPresented, alert: .delete) {
                    viewStore.send(.removeVoteTapped(vote), animation: .default)
                  }

              default:
                RoundedRectangle(cornerRadius: 24)
                  .fill(.gray)
                  .aspectRatio(1, contentMode: .fit)
                  .overlay(alignment: .topTrailing) {
                    Button {
                      viewStore.send(.binding(.set(\.$isDeletionPresented, true)))
                    } label: {
                      Image(icon: .delete)
                        .padding(8)
                    }
                  }
                  .alert(isPresented: viewStore.$isDeletionPresented, alert: .delete) {
                    viewStore.send(.removeVoteTapped(vote))
                  }
              }
            }
          }
        }
      }
      .scrollIndicators(.hidden)
      .padding(18)
      .smNavigationBar(title: "편집") {
        Button {
          viewStore.send(.dismissButtonTapped)
        } label: {
          Text("취소")
            .foregroundColor(.ds(.white80))
            .font(.ds(.title2(.semibold)))
        }
      } rightItems: {
        Button {
          viewStore.send(.confirmButtonTapped)
        } label: {
          Text("확인")
            .foregroundColor(.ds(.green1))
            .font(.ds(.title2(.semibold)))
        }
      }
      .onAppear {
        viewStore.send(._onAppear)
      }
    }
  }
}

struct UploadListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      UploadListView(store: .init(initialState: .init(), reducer: {
        UploadListCore()
      }))
    }
    .preferredColorScheme(.dark)
  }
}
