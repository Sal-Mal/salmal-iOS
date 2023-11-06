import SwiftUI
import ComposableArchitecture

import Core
import UI

public struct PhotoEditorView: View {

  private let store: StoreOf<PhotoEditorCore>

  public init(store: StoreOf<PhotoEditorCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        SMNavigationView(
          leftText: "취소",
          leftAction: {
            viewStore.send(.backButtonTapped)
          },
          rightText: "확인",
          rightAction: {
            viewStore.send(.confirmButtonTapped(photoView))
          }
        )

        ZStack {
          // 이미지 필터링
          VStack(spacing: 0) {
            // 메인 사진
            photoView
              .padding(.horizontal, 16)

            Spacer().frame(height: 12)

            if viewStore.isChanging {
              VStack {
                Circle()
                  .stroke(style: .init(lineWidth: 1))
                  .frame(width: 42, height: 42)
                  .scaleEffect(viewStore.isHovering ? 1.2 : 1)
                  .animation(.spring(response: 0.2, dampingFraction: 0.9), value: viewStore.isHovering)
                  .overlay {
                    Image(icon: .xmark_circle)
                      .renderingMode(.template)
                      .foregroundColor(.ds(.white))
                  }
              }
              .frame(height: 200)
              .frame(maxWidth: .infinity)
              .background(Color.clear)

            } else {
              VStack {
                filteredPhotoScrollView

                Spacer().frame(height: 24)

                PhotoEditorTextAddButton {
                  viewStore.send(.addTextButtonTapped, animation: .linear(duration: 0.2))
                }

                Spacer().frame(height: 30)
              }
              .frame(height: 200)
            }
          }
          .ignoresSafeArea(.keyboard, edges: .bottom)

          // 텍스트 설정 모달
          IfLetStore(
            store.scope(state: \.$destination, action: { .destination($0) }),
            state: /PhotoEditorCore.Destination.State.photoTextEditor,
            action: PhotoEditorCore.Destination.Action.photoTextEditor,
            then: PhotoTextEditorView.init(store:)
          )
        }
        .onAppear {
          viewStore.send(._onAppear)
        }
      }
    }
  }

  var photoView: some View {
    PhotoView(store: store)
  }

  /// 필터 처리된 사진
  var filteredPhotoScrollView: some View {
    WithViewStore(store, observe: { $0.filteredImage }) { viewStore in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          Spacer()
          ForEach(viewStore.state, id: \.id) { filteredImage in
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
    }
  }
}

struct PhotoView: View {

  let store: StoreOf<PhotoEditorCore>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        if let uiImage = viewStore.image {
          Image(uiImage: uiImage)
            .resizable()
            .cornerRadius(24)
        } else {
          Rectangle()
            .frame(maxHeight: .infinity)
            .foregroundColor(Color.ds(.gray1))
            .cornerRadius(24)
            .padding(.horizontal, 16)
        }

        ForEach(viewStore.photoTextBoxes) { textBox in
          Text(textBox.text)
            .font(textBox.font)
            .foregroundColor(textBox.textColor)
            .padding(.init(top: 2, leading: 4, bottom: 2, trailing: 4))
            .background {
              RoundedRectangle(cornerRadius: 4).fill(textBox.backgroundColor)
            }
            .scaleEffect(textBox.isHovering ? 0.3 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.9), value: textBox.isHovering)
            .offset(textBox.offset)
            .gesture(
              DragGesture(coordinateSpace: .global)
                .onChanged { gesture in
                  let lastOffset = textBox.lastOffset
                  let newOffset = lastOffset + gesture.translation
                  viewStore.send(.textBoxOffsetChanged(textBox, offset: newOffset))
                  viewStore.send(.set(\.$isChanging, true))
                  if gesture.location.y >= UIScreen.main.bounds.height - 250 {
                    viewStore.send(.textBoxOffsetHovering(textBox, isHovering: true))
                  } else {
                    viewStore.send(.textBoxOffsetHovering(textBox, isHovering: false))
                  }
                }
                .onEnded { gesture in
                  if gesture.location.y >= UIScreen.main.bounds.height - 250 {
                    viewStore.send(.textBoxDeleteAreaEntered(textBox))
                  } else {
                    viewStore.send(.textBoxOffsetEnded(textBox, offset: gesture.translation))
                  }
                  viewStore.send(.set(\.$isChanging, false))
                  viewStore.send(.textBoxOffsetHovering(textBox, isHovering: false))
                }
            )
        }
      }
    }
  }
}


struct UploadEditPhotoView_Previews: PreviewProvider {
  static var previews: some View {
    PhotoEditorView(store: .init(initialState: .init(uiImage: nil), reducer: {
      PhotoEditorCore()
    }))
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}

