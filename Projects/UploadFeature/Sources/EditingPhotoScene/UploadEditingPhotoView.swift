import SwiftUI
import ComposableArchitecture
import PhotosUI

import UI

public struct UploadEditingPhotoView: View {

  private let store: StoreOf<UploadEditingPhotoCore>
  @ObservedObject var viewStore: ViewStoreOf<UploadEditingPhotoCore>

  public init(store: StoreOf<UploadEditingPhotoCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }

  public var body: some View {
    ZStack {
      VStack(spacing: 0) {
        Image(uiImage: UIImage(data: viewStore.imageData) ?? .init())
          .resizable()
          .scaledToFit()
          .frame(maxHeight: .infinity)
          .background(.green)
          .cornerRadius(24)
          .padding(.horizontal, 16)
          .debug()
          .onChange(of: viewStore.imageData) { data in
            print(data)
            viewStore.send(.applyImageFilters(data))
          }

        Spacer().frame(height: 12)

        ScrollView(.horizontal) {
          HStack {
            Spacer()
            ForEach(viewStore.filteredImage) { filteredImage in
              Image(uiImage: filteredImage.image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 86, height: 86)
                .cornerRadius(12)
            }
          }
          .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .frame(height: 86)
        .debug()

        Spacer().frame(height: 24)

        Button {
          viewStore.send(.textUploadButtonTapped, animation: .linear(duration: 0.2))
        } label: {
          HStack(spacing: 8) {
            Circle()
              .stroke(style: .init(lineWidth: 1, dash: [2]))
              .frame(width: 32, height: 32)
              .overlay {
                Image(icon: .plus)
                  .renderingMode(.template)
                  .foregroundColor(.ds(.white))
              }
            Text("텍스트 추가")
              .font(.ds(.title2(.medium)))
          }
          .tint(.ds(.white))
        }
      }
      .ignoresSafeArea(.keyboard, edges: .bottom)

      if viewStore.textUploadState != nil {
        UploadEditingTextView(store: .init(initialState: .init(), reducer: {
          UploadEditingTextCore()
        }))

      }
    }
    .tabViewStyle(.page)
    .smNavigationBar(
      title: "",
      leftItems: {
        Button {
          viewStore.send(.cancelButtonTapped, animation: .linear(duration: 0.1))
        } label: {
          Text("취소")
            .foregroundColor(.ds(.white80))
            .font(.ds(.title2(.semibold)))
        }

      },
      rightItems: {
        Button {
          viewStore.send(.confirmButtonTapped)
        } label: {
          Text("확인")
            .foregroundColor(.ds(.green1))
            .font(.ds(.title2(.semibold)))
        }
      }
    )
    .photosPicker(isPresented: viewStore.$isPhotoLibraryPresented, selection: viewStore.$selectedItem)
  }
}


struct UploadEditPhotoView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      UploadEditingPhotoView(store: .init(initialState: .init(uiImage: nil), reducer: {
        UploadEditingPhotoCore()
      }))
    }
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
