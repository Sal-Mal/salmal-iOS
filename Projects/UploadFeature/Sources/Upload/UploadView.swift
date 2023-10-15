import SwiftUI
import ComposableArchitecture

import UI
import CoreImage

//CIColorCurves
//CIColor

public struct UploadView: View {

  private let store: StoreOf<UploadCore>

  public init(store: StoreOf<UploadCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
        VStack(spacing: 0) {
          ZStack {
            Image(systemName: "house")
              .resizable()
              .scaledToFit()
              .frame(maxHeight: .infinity)
              .background(.green)
              .cornerRadius(24)
              .padding(.top, 16)
              .padding(.horizontal, 16)
              .debug()
          }

          Spacer().frame(height: 12)

          ScrollView(.horizontal) {
            LazyHGrid(rows: [.init()]) {
              Rectangle().fill(.gray)
                .frame(width: 86, height: 86)
                .cornerRadius(12)

              Rectangle().fill(.gray)
                .frame(width: 86, height: 86)
                .cornerRadius(12)

              Rectangle().fill(.gray)
                .frame(width: 86, height: 86)
                .cornerRadius(12)

              Rectangle().fill(.gray)
                .frame(width: 86, height: 86)
                .cornerRadius(12)

              Rectangle().fill(.gray)
                .frame(width: 86, height: 86)
                .cornerRadius(12)
            }
          }
          .scrollIndicators(.hidden)
          .frame(height: 86)
          .debug()

          Spacer().frame(height: 27)

          Button {
            viewStore.send(.textUploadButtonTapped)
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
          .fullScreenCover(store: store.scope(state: \.$textUploadState, action: { .textUpload($0) })) { store in
            TextUploadView()
          }
        }
      .tabViewStyle(.page)
      .smNavigationBar(
        title: "",
        leftItems: {
          Button {

          } label: {
            Text("취소")
              .foregroundColor(.ds(.white80))
              .font(.ds(.title2(.semibold)))
          }

        },
        rightItems: {
          Button {

          } label: {
            Text("확인")
              .foregroundColor(.ds(.green1))
              .font(.ds(.title2(.semibold)))
          }
        }
      )
    }
  }
}


struct UploadView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      UploadView(store: .init(initialState: .init(), reducer: {
        UploadCore()
      }))
    }
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
