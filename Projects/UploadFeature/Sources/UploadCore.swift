import UIKit
import ComposableArchitecture
import Photos

import Core

public struct UploadCore: Reducer {

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    @BindingState var isCameraSheetPresented: Bool = false
    @BindingState var isPhotoLibraryAuthorized: Bool = false
    @BindingState var isLoading: Bool = false

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
    case _fetchPhotoLibraryResponse([UploadMenu])

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
          guard let asset = menu.asset else { return .none }

          let ratio: CGFloat = 1.4
          let width: CGFloat = UIScreen.main.bounds.width
          let size = CGSize(width: width, height: width * ratio)

          guard let uiImage = try? photoService.fetchImage(for: asset, size: size) else {
            return .none
          }
          state.destination = .photoEditor(.init(uiImage: uiImage))
          return .none
        }

      case .cameraTakeButtonTapped(let uiImage):
        state.isCameraSheetPresented = false
        state.destination = .photoEditor(.init(uiImage: uiImage))
        return .none

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
        state.isLoading = true
        let ratio = 1.4
        let width = UIScreen.main.bounds.width / 3
        let size = CGSize(width: width, height: width * ratio)

        let assets = photoService.fetchAssets()

        return .run { send in
          let menus = await withTaskGroup(of: UploadMenu?.self, returning: [UploadMenu].self) { group in
            for asset in assets {
              group.addTask {
                guard let uiImage = try? photoService.fetchImage(for: asset, size: size) else {
                  return nil
                }
                let menu = UploadMenu(type: .library, uiImage: uiImage, asset: asset)
                return menu
              }
            }

            var menus = [UploadMenu]()
            for await menu in group {
              if let menu {
                menus.append(menu)
              }
            }

            menus.sort {
              guard let lhs = $0.asset?.creationDate,
                    let rhs = $1.asset?.creationDate else { return false }
              return lhs > rhs
            }
            return menus
          }

          await send(._fetchPhotoLibraryResponse(menus))
        }

      case ._fetchPhotoLibraryResponse(let menus):
        state.isLoading = false
        state.menus = [UploadMenu(type: .camera)] + menus
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
