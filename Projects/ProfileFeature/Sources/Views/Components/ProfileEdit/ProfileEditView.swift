import SwiftUI
import PhotosUI
import AVFoundation
import ComposableArchitecture

import Core
import UI

public struct ProfileEditView: View {

  private let store: StoreOf<ProfileEditCore>

  public init(store: StoreOf<ProfileEditCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Spacer()

        VStack(spacing: 24) {
          if let imageData = viewStore.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
              .resizable()
              .scaledToFill()
              .frame(width: 80, height: 80)
              .clipShape(Circle())
              .overlay {
                Circle()
                  .stroke(lineWidth: 2)
                  .foregroundColor(.ds(.white))
              }
          } else {
            if let url = URL(string: viewStore.member?.imageURL ?? "") {
              CacheAsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                  image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay {
                      Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.ds(.white))
                    }

                default:
                  Circle()
                    .fill(.gray)
                    .frame(width: 80, height: 80)
                    .overlay {
                      Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.ds(.white))
                    }
                }
              }
            } else {
              Circle()
                .fill(.gray)
                .frame(width: 80, height: 80)
                .overlay {
                  Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.ds(.white))
                }
            }
          }

          Button {
            viewStore.send(.binding(.set(\.$isPhotoSheetPresented, true)))
          } label: {
            Text("사진 변경")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.green1))
          }
        }

        Spacer()

        VStack(spacing: 42) {
          VStack(alignment: .leading) {
            Text("닉네임")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.gray2))
            SMCapsuleTextField(
              text: viewStore.$nickName,
              placeholder: "닉네임을 입력해주세요"
            )
            .font(.pretendard(.regular, size: 16))
          }

          VStack(alignment: .leading) {
            Text("한줄 소개")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.gray2))
            SMCapsuleTextField(
              text: viewStore.$introduction,
              placeholder: "소개를 입력해주세요"
            )
            .font(.pretendard(.regular, size: 16))
          }
        }

        Spacer()

        VStack(spacing: 24) {
          Button {
            viewStore.send(.logoutButtonTapped)
          } label: {
            Text("로그아웃")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.green1))
          }

          Button {
            viewStore.send(.binding(.set(\.$isWithdrawalPresented, true)))
          } label: {
            Text("서비스 탈퇴")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.gray2))
          }
        }
      }
      .smNavigationBar(
        title: "개인정보 수정",
        leftItems: {
          Button {
            viewStore.send(.dismissButtonTapped)
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
      .bottomSheet(isPresented: viewStore.$isPhotoSheetPresented) {
        VStack(spacing: 0) {
          MenuButton(icon: Image(icon: .gallery), title: "사진첩에서 선택하기") {
            viewStore.send(.selectInPhotoLibraryButtonTapped)
          }

          MenuButton(icon: Image(icon: .camera), title: "촬영하기") {
            viewStore.send(.takePhotoButtonTapped)
          }

          MenuButton(icon: Image(icon: .ic_trash), title: "현재 사진 삭제") {
            viewStore.send(.removeCurrentPhotoButtonTapped)
          }
        }
        .padding(.top, 43)
      }
      .alert(
        isPresented: viewStore.$isWithdrawalPresented,
        alert: .withdrawal
      ) {
        viewStore.send(.withdrawalButtonTapped)
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
      .sheet(isPresented: viewStore.$isTakePhotoPresented) {
        SMImagePicker { data in
          viewStore.send(.setImage(data))
        } onDismiss: {
          viewStore.send(.cancelTakePhotoButtonTapped)
        }
      }
      .photosPicker(isPresented: viewStore.$isPhotoLibraryPresented, selection: viewStore.$selectedItem)
    }
  }

  func MenuButton(icon: Image, title: String, action: (() -> Void)? = nil) -> some View {
    Button {
      action?()
    } label: {
      HStack(spacing: 6) {
        icon
          .renderingMode(.template)
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(width: 32)
          .padding(.leading, 18)

        Text(title)
          .font(.ds(.title3(.medium)))
      }
      .foregroundColor(.ds(.white))
      .frame(height: 60)
      .frame(maxWidth: .infinity, alignment: .leading)
      .contentShape(Rectangle())
    }
  }

}

struct ProfileEditView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ProfileEditView(store: .init(initialState: .init(), reducer: {
        ProfileEditCore()._printChanges()
      }))
    }
    .padding()
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
