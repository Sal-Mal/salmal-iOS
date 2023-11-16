import UIKit
import SwiftUI
import PhotosUI
import AVFoundation
import ComposableArchitecture

import Core

public struct ProfileEditCore: Reducer {

  public struct State: Equatable {
    @BindingState var nickName: String = ""
    @BindingState var introduction: String = ""
    @BindingState var isProfileImageSheetPresented: Bool = false
    @BindingState var isPhotoLibrarySheetPresented: Bool = false
    @BindingState var isCameraSheetPresented: Bool = false
    @BindingState var isWithdrawalSheetPresented: Bool = false
    @BindingState var selectedItem: PhotosPickerItem?

    var member: Member?
    var imageData: Data?

    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case backButtonTapped
    case confirmButtonTapped
    case changeProfileImageButtonTapped
    case showPhotoLibrarySheetButtonTapped
    case showCameraSheetButtonTapped
    case cancelCameraSheetButtonTapped
    case takePhotoButtonTapped(UIImage)
    case removeCurrentPhotoButtonTapped
    case logoutButtonTapped
    case withdrawalButtonTapped

    case _onAppear
    case _setMember(Member)
    case _setImage(UIImage?)
    case _presentPhotoLibrarySheet
    case _presentCameraSheet

    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.memberRepository) var memberRepository
  @Dependency(\.authRepository) var authRepository
  @Dependency(\.photoService) var photoService
  @Dependency(\.toastManager) var toastManager

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await dismiss()
        }

      case .confirmButtonTapped:
        guard let imageData = state.imageData else {
          return .run { send in
            await toastManager.showToast(.error("이미지 데이터가 없어요."))
          }
        }

        return .run { [nickName = state.nickName, introduction = state.introduction, data = imageData] send in
          try await memberRepository.update(nickname: nickName, introduction: introduction)
          try await memberRepository.updateImage(data: data)
          await dismiss()

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case .changeProfileImageButtonTapped:
        state.isProfileImageSheetPresented = true
        return .none

      case .showPhotoLibrarySheetButtonTapped:
        state.isProfileImageSheetPresented = false
        return .run { send in
          try await Task.sleep(for: .milliseconds(100))
          await send(._presentPhotoLibrarySheet)
        }

      case .showCameraSheetButtonTapped:
        state.isProfileImageSheetPresented = false
        return .run { send in
          try await Task.sleep(for: .milliseconds(100))
          await send(._presentCameraSheet)
        }

      case .cancelCameraSheetButtonTapped:
        state.isCameraSheetPresented = false
        return .none

      case .takePhotoButtonTapped(let uiImage):
        state.isCameraSheetPresented = false
        return .send(._setImage(uiImage))

      case .removeCurrentPhotoButtonTapped:
        state.isProfileImageSheetPresented = false
        state.imageData = nil
        return .none

      case .logoutButtonTapped:
        return .run { send in
          try await authRepository.logOut()
          NotificationService.post(.logout)
        } catch: { error, send in
          await toastManager.showToast(.error("로그아웃에 실패했어요."))
        }

      case .withdrawalButtonTapped:
        return .run { send in
          try await memberRepository.delete()
          NotificationService.post(.logout)
        } catch: { error, send in
          await toastManager.showToast(.error("회원탈퇴에 실패했어요."))
        }

      case ._onAppear:
        return .run { send in
          let member = try await memberRepository.myPage()
          await send(._setMember(member))
        }

      case ._setMember(let member):
        state.member = member
        state.nickName = member.nickName
        state.introduction = member.introduction
        return .none

      case ._setImage(let uiImage):
        guard let uiImage else { return .none }

        let imageData = photoService.exportCompressedImage(uiImage)
        state.imageData = imageData
        return .none

      case ._presentPhotoLibrarySheet:
        state.isPhotoLibrarySheetPresented = true
        return .none

      case ._presentCameraSheet:
        state.isCameraSheetPresented = true
        return .none

      case .binding(\.$selectedItem):
        guard let item = state.selectedItem else { return .none }

        return .run { send in
          guard let data = try await item.loadTransferable(type: Data.self) else {
            return
          }

          let uiImage = UIImage(data: data)
          await send(._setImage(uiImage))

        } catch: { error, send in
          await toastManager.showToast(.error(error.localizedDescription))
        }

      case .binding:
        return .none
      }
    }
  }
}
