import SwiftUI
import ComposableArchitecture
import Kingfisher

import Core
import UI

struct UploadListView: View {
  
  private let store: StoreOf<UploadListCore>
  
  public init(store: StoreOf<UploadListCore>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        if viewStore.votes.isEmpty {
          VStack(spacing: 6) {
            Text("편집 가능한 투표가 없습니다.")
              .font(.ds(.title3(.semibold)))
            
            Text("새로운 투표를 업로드 해주세요.")
              .foregroundColor(.ds(.gray3))
              .font(.ds(.title4(.medium)))
          }
          .frame(maxHeight: .infinity)
          
        } else {
          ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [.init(), .init()], spacing: 8) {
              ForEach(viewStore.votes, id: \.id) { vote in
                KFImage(URL(string: vote.imageURL))
                  .resizable()
                  .aspectRatio(1, contentMode: .fit)
                  .cornerRadius(24)
                  .overlay(alignment: .topTrailing) {
                    Button {
                      viewStore.send(.remoteButtonTapped(vote))
                    } label: {
                      Image(icon: .delete)
                        .padding(8)
                    }
                  }
              }
            }
          }
          .padding(18)
        }
      }
      .alert(isPresented: viewStore.$isDeletionPresented, alert: .delete) {
        store.send(.deleteButtonTapped)
      }
      .smNavigationBar(title: "편집", leftItems: {
        Button {
          viewStore.send(.dismissButtonTapped)
        } label: {
          Text("취소")
            .foregroundColor(.ds(.white80))
            .font(.ds(.title2(.semibold)))
        }
      })
      .onAppear {
        viewStore.send(._onAppear)
        NotificationService.post(.hideTabBar)
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
