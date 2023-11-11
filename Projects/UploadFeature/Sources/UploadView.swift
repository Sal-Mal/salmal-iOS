import SwiftUI
import ComposableArchitecture

import UI

public struct UploadView: View {

  private let store: StoreOf<UploadCore>

  public init(store: StoreOf<UploadCore>) {
    self.store = store
  }

  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  @Environment(\.dismiss) var dismiss

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        SMNavigationView(title: "사진 추가", rightIcon: Image(icon: .xmark)) {
          viewStore.send(.backButtonTapped)
          dismiss()
        }

        ZStack {
          if viewStore.isPhotoLibraryAuthorized {
            VStack(spacing: 0) {
              //sortTopNavigationBar

              ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                  ForEach(viewStore.menus) { menu in
                    UploadMenuView(menu: menu)
                      .onTapGesture { viewStore.send(.menuTapped(menu)) }
                  }
                }
                .padding(.horizontal, 5)
              }
            }
          } else {
            VStack(spacing: 16) {
              Text("사진 접근 권한을 허용해주세요")
                .font(.ds(.title2(.semibold)))
                .foregroundColor(.ds(.white))

              Text("더 쉽게 편하게 사진을 올릴 수 있어요.")
                .font(.ds(.title4(.medium)))
                .foregroundColor(.ds(.gray3))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.ds(.black))
          }
        }
      }
      .onAppear { viewStore.send(._onAppear) }
      .fullScreenCover(isPresented: viewStore.$isCameraSheetPresented) {
        SMImagePicker(onCapture: {
          viewStore.send(.cameraTakeButtonTapped($0))

        }, onDismiss: {
          viewStore.send(.cameraCancelButtonTapped)
        })
        .frame(maxHeight: .infinity)
      }
      .sheet(
        store: store.scope(state: \.$destination, action: { .destination($0) }),
        state: /UploadCore.Destination.State.photoAlbum,
        action: UploadCore.Destination.Action.photoAlbum,
        content: PhotoAlbumView.init(store:)
      )
      .fullScreenCover(
        store: store.scope(state: \.$destination, action: { .destination($0) }),
        state: /UploadCore.Destination.State.photoEditor,
        action: UploadCore.Destination.Action.photoEditor,
        content: PhotoEditorView.init(store:)
      )
      .onDisappear { viewStore.send(._onDisappear) }
    }
  }

  private var sortTopNavigationBar: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        Button {
          viewStore.send(.selectPhotoAlbumButtonTapped)
        } label: {
          HStack {
            Text("최근")
              .font(.ds(.title4(.medium)))

            Image(systemName: "chevron.down")
              .resizable()
              .scaledToFit()
              .frame(width: 10, height: 10)
          }
          .foregroundColor(.ds(.white))
        }

        Spacer()
      }
      .padding(.horizontal, 18)
      .frame(height: 24)
    }
  }
}

private struct UploadMenuView: View {
  let menu: UploadMenu

  var body: some View {
    if menu.type == .camera {
      Rectangle()
        .fill(Color.ds(.black))
        .aspectRatio(0.64, contentMode: .fit)
        .cornerRadius(6)
        .overlay {
          VStack(spacing: 5) {
            Image(icon: .camera)
            Text("촬영")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.white))
          }
        }

    } else {
      if let uiImage = menu.uiImage {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(0.64, contentMode: .fit)
          .cornerRadius(6)

      } else {
        Rectangle()
          .fill(Color.ds(.gray1))
          .aspectRatio(0.64, contentMode: .fit)
          .cornerRadius(6)
      }
    }
  }
}

struct UploadView_Previews: PreviewProvider {
  static var previews: some View {
    UploadView(store: .init(initialState: .init(), reducer: {
      UploadCore()._printChanges()
    }))
    .preferredColorScheme(.dark)
  }
}
