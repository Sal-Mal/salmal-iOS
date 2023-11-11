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
      VStack(spacing: 0) {
        Spacer()

        VStack(spacing: 24) {
          if let imageData = viewStore.imageData, let uiImage = UIImage(data: imageData) {
            profileImageView(image: Image(uiImage: uiImage))

          } else {
            if let url = URL(string: viewStore.member?.imageURL ?? "") {
              CacheAsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                  profileImageView(image: image)

                default:
                  defaultProfileImageView
                }
              }
            } else {
              defaultProfileImageView
            }
          }

          Button {
            viewStore.send(.changeProfileImageButtonTapped)
          } label: {
            Text("사진 변경")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.green1))
          }
        }

        Spacer().frame(height: 98)

        // 닉네임 & 한줄 소개 입력
        VStack(spacing: 42) {
          VStack(alignment: .leading) {
            Text("닉네임")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.gray2))

            SMCapsuleTextField(
              text: viewStore.$nickName,
              placeholder: "닉네임을 입력해주세요"
            )
            .color(.placeholder(.clear))
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
            .color(.placeholder(.clear))
            .font(.pretendard(.regular, size: 16))
          }
        }
        .padding(.horizontal, 18)

        Spacer()

        // 로그아웃 & 회원탈퇴
        VStack(spacing: 24) {
          Button {
            viewStore.send(.logoutButtonTapped)
          } label: {
            Text("로그아웃")
              .font(.ds(.title4(.medium)))
              .foregroundColor(.ds(.green1))
          }

          Button {
            viewStore.send(.withdrawalButtonTapped)
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
            viewStore.send(.backButtonTapped)
          } label: {
            Text("취소")
              .font(.ds(.title2(.semibold)))
              .foregroundColor(.ds(.white80))
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
      .bottomSheet(isPresented: viewStore.$isProfileImageSheetPresented) {
        VStack(spacing: 0) {
          menuButton(icon: Image(icon: .gallery), title: "사진첩에서 선택하기") {
            viewStore.send(.showPhotoLibrarySheetButtonTapped)
          }

          menuButton(icon: Image(icon: .camera), title: "촬영하기") {
            viewStore.send(.showCameraSheetButtonTapped)
          }

          // TODO: - 현재 사진 삭제 API 나올 때까지 주석
          /*
          menuButton(icon: Image(icon: .ic_trash), title: "현재 사진 삭제") {
            viewStore.send(.removeCurrentPhotoButtonTapped)
          }
           */
        }
        .padding(.top, 43)
      }
      .onAppear {
        viewStore.send(._onAppear)
        NotificationService.post(.hideTabBar)
      }
      .photosPicker(
        isPresented: viewStore.$isPhotoLibrarySheetPresented,
        selection: viewStore.$selectedItem
      )
      .fullScreenCover(isPresented: viewStore.$isCameraSheetPresented) {
        SMImagePicker(onCapture: {
          viewStore.send(.takePhotoButtonTapped($0))
        }, onDismiss: {
          viewStore.send(.cancelCameraSheetButtonTapped)
        })
        .ignoresSafeArea(.all, edges: .bottom)
      }
      .alert(isPresented: viewStore.$isWithdrawalSheetPresented, alert: .withdrawal) {
        viewStore.send(.withdrawalButtonTapped)
      }
    }
    .ignoresSafeArea(.keyboard)
  }

  func profileImageView(image: Image) -> some View {
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
  }

  var defaultProfileImageView: some View {
    Circle()
      .fill(.gray)
      .frame(width: 80, height: 80)
      .overlay {
        Circle()
          .stroke(lineWidth: 2)
          .foregroundColor(.ds(.white))
      }
  }

  func menuButton(icon: Image, title: String, action: (() -> Void)? = nil) -> some View {
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
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
