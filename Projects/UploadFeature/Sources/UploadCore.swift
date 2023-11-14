import UIKit
import ComposableArchitecture
import Photos

import Core

public struct UploadCore: Reducer {

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    @BindingState var isCameraSheetPresented: Bool = false
    @BindingState var isPhotoLibraryAuthorized: Bool = false

    var menus: [UploadMenu] = [UploadMenu(type: .camera)]

    public init() {}
  }

  public enum Action: BindableAction {
    // MARK: - 외부 Action
    case backButtonTapped
    case selectPhotoAlbumButtonTapped
    case menuTapped(UploadMenu)
    case cameraTakeButtonTapped(UIImage)
    case cameraCancelButtonTapped

    // MARK: - 내부 Action
    case _onAppear
    case _requestPhotoLibraryAuthorization
    case _requestPhotoLibraryAuthorizationResponse(TaskResult<Void>)
    case _fetchPhotoLibrary
    case _fetchPhotoLibraryResponse([UIImage])
    case _onDisappear

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

      case .selectPhotoAlbumButtonTapped:
        state.destination = .photoAlbum(.init())
        return .none

      case .menuTapped(let menu):
        if menu.type == .camera {
          state.isCameraSheetPresented = true
          return .none

        } else {
          guard let uiImage = menu.uiImage else { return .none }
          state.destination = .photoEditor(.init(uiImage: uiImage))
          return .none
        }

      case .cameraTakeButtonTapped(let uiImage):
        state.isCameraSheetPresented = false
        return .send(.menuTapped(.init(type: .library, uiImage: uiImage)))

      case .cameraCancelButtonTapped:
        state.isCameraSheetPresented = false
        return .none

      case ._onAppear:
        return .send(._requestPhotoLibraryAuthorization)

      case ._requestPhotoLibraryAuthorization:
        return .run { send in
          await send(._requestPhotoLibraryAuthorizationResponse(TaskResult<Void> {
            try await photoService.requestAuthorization()
          }))
        }

      case ._requestPhotoLibraryAuthorizationResponse(.success):
        state.isPhotoLibraryAuthorized = true
        return .send(._fetchPhotoLibrary)

      case ._requestPhotoLibraryAuthorizationResponse(.failure(let error)):
        state.isPhotoLibraryAuthorized = false
        return .run { [error] send in
          await toastManager.showToast(.warning(error.localizedDescription))
        }

      case ._fetchPhotoLibrary:
        return .run { send in
          let uiImages = try await photoService.albums()
          await send(._fetchPhotoLibraryResponse(uiImages))
        } catch: { error, send in
          await toastManager.showToast(.warning(error.localizedDescription))
        }

      case ._fetchPhotoLibraryResponse(let uiImages):
        var menus = [UploadMenu(type: .camera)]
        menus += uiImages.map { UploadMenu(type: .library, uiImage: $0) }
        state.menus = menus
        return .none

      case ._onDisappear:
        return .none

      case .destination(.presented(.photoEditor(.delegate(.savePhoto)))):
        return .run { send in
          await dismiss()
        }

      case .destination:
        return .none

      case .binding:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) { Destination() }
  }

  public struct Destination: Reducer {
    public enum State: Equatable {
      case photoAlbum(PhotoAlbumCore.State)
      case photoEditor(PhotoEditorCore.State)
    }

    public enum Action {
      case photoAlbum(PhotoAlbumCore.Action)
      case photoEditor(PhotoEditorCore.Action)
    }

    public var body: some ReducerOf<Destination> {
      Scope(state: /State.photoAlbum, action: /Action.photoAlbum) { PhotoAlbumCore() }
      Scope(state: /State.photoEditor, action: /Action.photoEditor) { PhotoEditorCore() }
    }
  }
}
