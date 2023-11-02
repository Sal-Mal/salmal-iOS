import UIKit
import ComposableArchitecture

public struct UploadCore: Reducer {

  public struct State: Equatable {

    public enum SortType: String, CaseIterable {
      case recent = "최근"
      case likeCount = "좋아요 수"
    }

    public struct ImageMenu: Equatable, Identifiable {
      enum MenuType {
        case camera
        case library
      }

      public let id: UUID = UUID()
      let type: MenuType
      var uiImage: UIImage?
    }

    var sortType: SortType = .recent
    var isSortBottomSheetPresented: Bool = false
    var isTakePhotoSheetPresented: Bool = false
    var imageMenus: [ImageMenu] = [.init(type: .camera)]
    @PresentationState var editingPhotoState: EditingPhotoCore.State?

    public init() {}
  }

  public enum Action {
    case backButtonTapped
    case showSortBottomSheet
    case imageMenuTapped(State.ImageMenu)
    case cameraCancelButtonTapped

    case _onAppear
    case _fetchPhotoLibraryResponse([UIImage])
    case _onDisappear

    case _setIsSortBottomSheetPresented(Bool)
    case _setIsTakePhotoSheetPresented(Bool)
    case _setSortType(State.SortType)
    case _setImageMenus([State.ImageMenu])

    case editingPhoto(PresentationAction<EditingPhotoCore.Action>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.photoService) var photoService

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await dismiss()
        }

      case .showSortBottomSheet:
        state.isSortBottomSheetPresented = true
        return .none

      case .imageMenuTapped(let imageMenu):
        if imageMenu.type == .camera {
          state.isTakePhotoSheetPresented = true
          return .none

        } else {
          state.editingPhotoState = .init(image: imageMenu.uiImage)
          return .none
        }

      case .cameraCancelButtonTapped:
        state.isTakePhotoSheetPresented = false
        return .none

      case ._onAppear:
        return .run { send in
          #warning("TODO: 권한 요청 후 -> 권한 획득 시 리로딩해야함")
          let images = await photoService.albums(size: .init(width: 1024, height: 1024)) // 앨범 이미지 사이즈? 화질 저하의 원인
          await send(._fetchPhotoLibraryResponse(images))
        }

      case ._fetchPhotoLibraryResponse(let uiImages):
        var imageMenus = [State.ImageMenu(type: .camera)]
        imageMenus += uiImages.map { State.ImageMenu(type: .library, uiImage: $0) }
        return .send(._setImageMenus(imageMenus))

      case ._onDisappear:
        return .none

      case ._setIsSortBottomSheetPresented(let isPresented):
        state.isSortBottomSheetPresented = isPresented
        return .none

      case ._setIsTakePhotoSheetPresented(let isPresented):
        state.isTakePhotoSheetPresented = isPresented
        return .none

      case ._setSortType(let sortType):
        state.sortType = sortType
        return .none

      case ._setImageMenus(let imageMenus):
        state.imageMenus = imageMenus
        return .none

      case .editingPhoto:
        return .none
      }
    }
    .ifLet(\.$editingPhotoState, action: /Action.editingPhoto) {
      EditingPhotoCore()
    }
  }
}
