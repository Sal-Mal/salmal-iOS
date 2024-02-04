import SwiftUI
import PhotosUI
import ComposableArchitecture

import UI

public struct UploadView: View {
  @State private var selectedItem: PhotosPickerItem?
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
        
        VStack(spacing: 20) {
          Spacer().frame(height: 150)
          
          VStack(spacing: 2) {
            Text("투표 등록 사진 선택")
              .font(.pretendard(.semiBold, size: 18))
              .foregroundStyle(.white)
            
            Text("투표 등록에 사용할 사진을 선택해주세요")
              .font(.pretendard(.regular, size: 14))
              .foregroundStyle(Color.ds(.gray2))
          }
          
          HStack(spacing: 16) {
            // 카메라 선택 버튼
            Button(action: { store.send(.selectInCamera) }, label: {
              VStack(spacing: 2) {
                Image(icon: .camera)
                  .renderingMode(.template)
                  .frame(width: 50, height: 50)
                  .foregroundStyle(.black)
                  
                Text("카메라")
                  .font(.pretendard(.semiBold, size: 16))
                  .foregroundStyle(.black)
              }
              .padding(18)
              .background {
                RoundedRectangle(cornerRadius: 6)
                  .fill(.white)
              }
            })
            .buttonStyle(.plain)
            
            // 갤러리 선택 버튼
            PhotosPicker(
              selection: .init(
                get: { selectedItem },
                set: {
                  selectedItem = $0
                  store.send(.photoSelected($0))
                }
              ),
              matching: .images
            ) {
              VStack(spacing: 2) {
                Image(icon: .bookmark)
                  .renderingMode(.template)
                  .frame(width: 50, height: 50)
                  .foregroundStyle(.black)
                  
                Text("갤러리")
                  .font(.pretendard(.semiBold, size: 16))
                  .foregroundStyle(.black)
              }
              .padding(18)
              .background {
                RoundedRectangle(cornerRadius: 6)
                  .fill(.white)
              }
            }
          }
          
          Spacer()
        }
      }
      .frame(maxHeight: .infinity)
      .background(.black)
      .onAppear {
        store.send(.onAppear)
      }
      .fullScreenCover(isPresented: viewStore.$isCameraSheetPresented) {
        SMImagePicker(
          onCapture: { viewStore.send(.cameraTaken($0)) },
          onDismiss: { viewStore.send(.cameraCancelled) }
        )
        .ignoresSafeArea()
      }
      .fullScreenCover(
        store: store.scope(state: \.$destination, action: { .destination($0) }),
        state: /UploadCore.Destination.State.photoEditor,
        action: UploadCore.Destination.Action.photoEditor,
        content: PhotoEditorView.init(store:)
      )
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
