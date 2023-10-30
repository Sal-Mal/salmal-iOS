import SwiftUI
import ComposableArchitecture

import UI

public struct UploadEditingPhotoView: View {

  private let store: StoreOf<UploadEditingPhotoCore>
  @ObservedObject private var viewStore: ViewStoreOf<UploadEditingPhotoCore>

  @State private var draggedOffset: CGSize = .zero
  @State private var accumulatedOffset: CGSize = .zero
  @State private var isChanging: Bool = false
  @State private var isHovering: Bool = false

  public init(store: StoreOf<UploadEditingPhotoCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }

  public var body: some View {
    ZStack {
      // 이미지 필터링
      VStack(spacing: 0) {
        // 메인 사진
        zzzzzzzzzzz

        Spacer().frame(height: 12)

        ZStack {
          if isChanging {
            VStack {
              Circle()
                .stroke(style: .init(lineWidth: 1))
                .frame(width: 42, height: 42)
                .scaleEffect(isHovering ? 1.2 : 1)
                .animation(.spring(), value: isHovering)
                .overlay {
                  Image(icon: .xmark_circle)
                    .renderingMode(.template)
                    .foregroundColor(.ds(.white))
                }
            }
            .frame(height: 160)

          } else {
            VStack {
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
            .frame(height: 160)
          }
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
          viewStore.send(.confirmButtonTapped(zzzzzzzzzzz))
        } label: {
          Text("확인")
            .foregroundColor(.ds(.green1))
            .font(.ds(.title2(.semibold)))
        }
      }
    )
  }
}

extension UploadEditingPhotoView {

  @ViewBuilder
  var zzzzzzzzzzz: some View {
    if let uiImage = viewStore.image {
      ZStack {
        Image(uiImage: uiImage)
          .resizable()
          .clipShape(
            RoundedRectangle(cornerRadius: 24)
          )
          .padding(.horizontal, 16)

        if let textInformation = viewStore.textInformation {
          Text(textInformation.text)
            .font(textInformation.font)
            .foregroundColor(textInformation.foregroundColor)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background {
              RoundedRectangle(cornerRadius: 4)
                .foregroundColor(textInformation.backgroundColor)
            }
            .offset(draggedOffset)
            .gesture(
              DragGesture(coordinateSpace: .global)
                .onChanged { gesture in
                  isChanging = true
                  draggedOffset = accumulatedOffset + gesture.translation

                  if gesture.location.y >= UIScreen.main.bounds.height - 160 {
                    isHovering = true
                  } else {
                    isHovering = false
                  }
                }
                .onEnded { gesture in
                  isChanging = false

                  if gesture.location.y >= UIScreen.main.bounds.height - 160 {
                    viewStore.send(.cancelArea)
                    accumulatedOffset = .zero
                    draggedOffset = .zero

                  } else {
                    accumulatedOffset = accumulatedOffset + gesture.translation
                  }
                }
            )
        }
      }

    } else {
      Rectangle()
        .frame(maxHeight: .infinity)
        .foregroundColor(Color.ds(.gray1))
        .cornerRadius(24)
        .padding(.horizontal, 16)
    }
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


extension CGSize {
  static func + (lhs: Self, rhs: Self) -> Self {
    CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }
}


extension View {

  func snapshot() -> UIImage {
    let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
    let view = controller.view

    let targetSize = controller.view.intrinsicContentSize
    view?.bounds = CGRect(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 600))
    view?.backgroundColor = .red

    let renderer = UIGraphicsImageRenderer(size: .init(width: UIScreen.main.bounds.width, height: 600))

    return renderer.image { _ in
      view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
  }
}
