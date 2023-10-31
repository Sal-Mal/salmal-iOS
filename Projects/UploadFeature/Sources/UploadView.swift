import SwiftUI
import ComposableArchitecture

public struct UploadView: View {

  private let store: StoreOf<UploadCore>
  @ObservedObject private var viewStore: ViewStoreOf<UploadCore>

  public init(store: StoreOf<UploadCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }


  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
      VStack {
        // 상단바
        HStack {
          Button {
            viewStore.send(.sortingButtonTapped)
          } label: {
            HStack {
              Text(viewStore.sortingType.rawValue)
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
        .sheet(isPresented: viewStore.$isSortingPresented) {
          UploadImageSortingBottomSheet(sortingType: viewStore.$sortingType)
            .presentationDetents([.fraction(0.3)])
            .presentationDragIndicator(.visible)
        }

        // 하단 이미지
        ScrollView(showsIndicators: false) {
          LazyVGrid(columns: [.init(), .init(), .init()]) {
            ForEach(viewStore.imageMenus) { imageMenu in
              UploadImageMenuView(imageMenu: imageMenu) {
                viewStore.send(.takePhotoButtonTapped)

              } onSelected: { uiImage in
                viewStore.send(.libraryPhotoSelected(uiImage))
              }
            }
          }
          .padding(.horizontal, 5)
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
      .toolbar(.hidden, for: .tabBar)
      .smNavigationBar(title: "사진 추가")
    } destination: { state in
      switch state {
      case .uploadEditingPhoto:
        CaseLet(
          /UploadCore.Path.State.uploadEditingPhoto,
           action: UploadCore.Path.Action.uploadEditingPhoto,
           then: UploadEditingPhotoView.init(store:)
        )
      }
    }
  }
}


struct UploadImageMenuView: View {

  let imageMenu: UploadCore.State.UploadImageMenu
  let takePhotoAction: () -> Void
  let onSelected: (UIImage?) -> Void

  var body: some View {
    if imageMenu.type == .takePhoto {
      Button {
        takePhotoAction()
      } label: {
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
      }

    } else {
      Button {
        onSelected(imageMenu.uiImage)
      } label: {
        if let uiImage = imageMenu.uiImage {
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
}

struct UploadImageSortingBottomSheet: View {

  @Binding var sortingType: UploadCore.State.UploadImageSortingType

  var body: some View {
    Picker("", selection: $sortingType) {
      ForEach(UploadCore.State.UploadImageSortingType.allCases, id: \.self) { type in
        Text(type.rawValue)
          .foregroundColor(.ds(.white))
          .font(.ds(.title2(.semibold)))
      }
    }
    .pickerStyle(.inline)
  }

}


struct UploadView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      UploadView(store: .init(initialState: .init(), reducer: {
        UploadCore()._printChanges()
      }))
    }
    .preferredColorScheme(.dark)
  }
}
