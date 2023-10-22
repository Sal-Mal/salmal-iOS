import UIKit
import ComposableArchitecture

public struct UploadCore: Reducer {

  public struct State: Equatable {

    struct UploadImageMenu: Equatable, Identifiable {
      enum UploadType {
        case takePhoto
        case library
      }

      let id: UUID = .init()
      let type: UploadType
      var uiImage: UIImage?
    }

    public enum UploadImageSortingType: String, CaseIterable {
      case recent = "최근"
      case like = "좋아요 수"
    }

    @BindingState var isSortingPresented: Bool = false
    @BindingState var sortingType: UploadImageSortingType = .recent
    var path = StackState<Path.State>()
    var imageMenus: [UploadImageMenu] = [.init(type: .takePhoto)]

    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    case binding(BindingAction<State>)
    case path(StackAction<Path.State, Path.Action>)
    case backButtonTapped
    case sortingButtonTapped
    case takePhotoButtonTapped
    case libraryPhotoSelected(UIImage?)
    case setImageMenus([UIImage])
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.photoService) var photoService

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let images = await PhotoService.shared.albums(size: .init(width: 200, height: 200))
          await send(.setImageMenus(images))
        }

      case .binding:
        return .none

      case .path:
        return .none

      case .backButtonTapped:
        return .run { send in
          await dismiss(animation: .default)
        }

      case .sortingButtonTapped:
        state.isSortingPresented = true
        return .none

      case .takePhotoButtonTapped:
        print("촬영 버튼 클릭")
        return .none

      case .libraryPhotoSelected(let image):
        state.path.append(.uploadEditingPhoto(.init(image: image)))
        return .none

      case .setImageMenus(let images):
        let imageMenus = [.init(type: .takePhoto)] + images.map { State.UploadImageMenu(type: .library, uiImage: $0) }
        state.imageMenus = imageMenus
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
  }


  public struct Path: Reducer, Equatable {
    public enum State: Equatable {
      case uploadEditingPhoto(UploadEditingPhotoCore.State?)
    }
    public enum Action {
      case uploadEditingPhoto(UploadEditingPhotoCore.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: /State.uploadEditingPhoto, action: /Action.uploadEditingPhoto) {
        UploadEditingPhotoCore()
      }
    }
  }

}
