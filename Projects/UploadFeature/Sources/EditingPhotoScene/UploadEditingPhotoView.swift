import SwiftUI
import ComposableArchitecture

import UI

public struct UploadEditingPhotoView: View {

  private let store: StoreOf<UploadEditingPhotoCore>
  @ObservedObject private var viewStore: ViewStoreOf<UploadEditingPhotoCore>

  public init(store: StoreOf<UploadEditingPhotoCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }

  public var body: some View {
    ZStack {
      // 이미지 필터링
      VStack(spacing: 0) {
        // 메인 사진
        if let uiImage = viewStore.image {
          Image(uiImage: uiImage)
            .resizable()
            .clipShape(
              RoundedRectangle(cornerRadius: 24)
            )
            .padding(.horizontal, 16)

        } else {
          Rectangle()
            .frame(maxHeight: .infinity)
            .foregroundColor(Color.ds(.gray1))
            .cornerRadius(24)
            .padding(.horizontal, 16)
        }

        Spacer().frame(height: 12)

        // 필터 처리된 사진
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            Spacer()
            ForEach(viewStore.filteredImage) { filteredImage in
              Button {
                viewStore.send(.filteredImageSelected(filteredImage))
              } label: {
                Image(uiImage: filteredImage.image)
                  .resizable()
                  .aspectRatio(1, contentMode: .fit)
                  .frame(width: 86, height: 86)
                  .cornerRadius(12)
              }
              .buttonStyle(.plain)
            }
          }
        }

        Spacer().frame(height: 24)

        // 텍스트 추가 버튼
        Button {
          viewStore.send(.uploadEditingTextButtonTapped, animation: .linear(duration: 0.2))
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
      .onAppear {
        viewStore.send(.onAppear)
      }

      // 텍스트 설정 모달
      IfLetStore(store.scope(state: \.$uploadEditingTextState, action: { .uploadEditingText($0) })) { store in
        UploadEditingTextView(store: store)
      }
    }
    .smNavigationBar(
      title: "",
      leftItems: {
        Button {
          viewStore.send(.backButtonTapped)
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
  }
}


struct UploadEditPhotoView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      UploadEditingPhotoView(store: .init(initialState: .init(image: nil), reducer: {
        UploadEditingPhotoCore()
      }))
    }
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
