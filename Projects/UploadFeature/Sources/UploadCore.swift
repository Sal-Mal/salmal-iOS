import UIKit
import SwiftUI
import PhotosUI
import ComposableArchitecture

import Core

public struct UploadCore: Reducer {

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    @BindingState var isCameraSheetPresented: Bool = false
    @BindingState var isLoading: Bool = false

    public init() {}
  }

  public enum Action: BindableAction {
    case backButtonTapped
    case selectInCamera
    case _requestCameraPermissionResponse(Bool)
    case cameraTaken(UIImage)
    case cameraCancelled
    case photoSelected(PhotosPickerItem?)
    case _loadImageCompletedResponse(UIImage)
    case _showPhotoEditScreen(UIImage)
    
    // MARK: - 기타 Action
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss
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
        
      case .selectInCamera:
        return .run { send in
          let isAuthorized = await PermissionService.requestCameraPermission()
          await send(._requestCameraPermissionResponse(isAuthorized))
        }
        
      case ._requestCameraPermissionResponse(let isAuthorized):
        if isAuthorized {
          state.isCameraSheetPresented = true
          return .none
        } else {
          return .run { send in
            await toastManager.showToast(.warning("카메라 접근 권한을 허용해주세요."))
          }
        }

      case .cameraTaken(let uiImage):
        state.isCameraSheetPresented = false
        
        return .run { send in
          try await Task.sleep(for: .seconds(1))
          await send(._showPhotoEditScreen(uiImage))
        }

      case .cameraCancelled:
        state.isCameraSheetPresented = false
        
      case .photoSelected(let item):
        return .run { send in
          guard let data = try? await item?.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: data) else { return }
          
          let isAuthorized = await PermissionService.requestPhotoPermission()
          
          if isAuthorized {
            await send(._loadImageCompletedResponse(uiImage))
          } else {
            await toastManager.showToast(.warning("앨범 접근 권한을 허용해주세요."))
          }
        }
        
      case ._loadImageCompletedResponse(let uiImage):
        return .run { send in
          try await Task.sleep(for: .seconds(1))
          await send(._showPhotoEditScreen(uiImage))
        }
        
      case let ._showPhotoEditScreen(uiImage):
        state.destination = .photoEditor(.init(uiImage: uiImage))
        
      case .destination(.presented(.photoEditor(.delegate(.savePhoto)))):
        return .run { send in
          await dismiss()
        }

      case .destination: break
      case .binding: break
      }
      
      return .none
    }
    .ifLet(\.$destination, action: /Action.destination) { Destination() }
  }

  public struct Destination: Reducer {
    public enum State: Equatable {
      case photoEditor(PhotoEditorCore.State)
    }

    public enum Action {
      case photoEditor(PhotoEditorCore.Action)
    }

    public var body: some ReducerOf<Destination> {
      Scope(state: /State.photoEditor, action: /Action.photoEditor) { PhotoEditorCore() }
    }
  }
}
