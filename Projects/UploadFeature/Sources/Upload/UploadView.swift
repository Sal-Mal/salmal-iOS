import SwiftUI
import ComposableArchitecture

import UI

public struct UploadView: View {

  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  private let store: StoreOf<UploadCore>

  public init(store: StoreOf<UploadCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        SMNavigationView(title: "사진 추가", rightIcon: Image(icon: .xmark)) {
          viewStore.send(.backButtonTapped)
        }

        sortTopNavigationBar

        ScrollView(showsIndicators: false) {
          LazyVGrid(columns: columns) {
            ForEach(viewStore.imageMenus) { imageMenu in
              ImageMenuView(imageMenu: imageMenu)
                .onTapGesture { viewStore.send(.imageMenuTapped(imageMenu)) }
            }
          }
          .padding(.horizontal, 5)
        }

      }
      .onAppear { viewStore.send(._onAppear) }
      .sheet(isPresented: viewStore.binding(
        get: \.isSortBottomSheetPresented,
        send: { ._setIsSortBottomSheetPresented($0) })
      ) {
        SortBottomSheet(sortType: viewStore.binding(
          get: \.sortType,
          send: { ._setSortType($0) }
        ))
      }
      .fullScreenCover(isPresented: viewStore.binding(
        get: \.isTakePhotoSheetPresented,
        send: { ._setIsTakePhotoSheetPresented($0) })
      ) {
        SMImagePicker { data in
          #warning("TODO: 데이터가 아닌 UIImage로 받도록 SMImagePicker를 수정해야함")
          let uiImage = UIImage(data: data!)
          viewStore.send(.imageMenuTapped(.init(type: .library, uiImage: uiImage)))

        } onDismiss: {
          viewStore.send(.cameraCancelButtonTapped)
        }
      }
      .fullScreenCover(store: store.scope(
        state: \.$editingPhotoState,
        action: { .editingPhoto($0) })
      ) { store in
        EditingPhotoView(store: store)
      }
      .onDisappear { viewStore.send(._onDisappear) }
    }
    .toolbar(.hidden, for: .navigationBar, .tabBar)
  }

  private var sortTopNavigationBar: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        Button {
          viewStore.send(.showSortBottomSheet)
        } label: {
          HStack {
            Text(viewStore.sortType.rawValue)
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

private struct SortBottomSheet: View {
  @Binding var sortType: UploadCore.State.SortType

  var body: some View {
    Picker("", selection: $sortType) {
      ForEach(UploadCore.State.SortType.allCases, id: \.self) {
        Text($0.rawValue)
          .font(.ds(.title2(.semibold)))
          .foregroundColor(.ds(.white))
      }
    }
    .pickerStyle(.inline)
    .presentationDetents([.fraction(0.3)])
    .presentationDragIndicator(.visible)
  }
}

private struct ImageMenuView: View {
  let imageMenu: UploadCore.State.ImageMenu

  var body: some View {
    if imageMenu.type == .camera {
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

struct UploadView_Previews: PreviewProvider {
  static var previews: some View {
    UploadView(store: .init(initialState: .init(), reducer: {
      UploadCore()._printChanges()
    }))
    .preferredColorScheme(.dark)
  }
}
