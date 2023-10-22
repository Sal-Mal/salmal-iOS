import Foundation
import ComposableArchitecture
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import PhotosUI

import Core

public struct UploadEditingPhotoCore: Reducer {

  public struct State: Equatable {

    @PresentationState var textUploadState: TextUploadCore.State?
    @BindingState var isPhotoLibraryPresented: Bool = false
    @BindingState var selectedItem: PhotosPickerItem?

    var imageData: Data = .init()
    var filteredImage: [FilteredImage] = []

    public init() {}
  }

  public enum Action: BindableAction {
    case textUpload(PresentationAction<TextUploadCore.Action>)
    case textUploadButtonTapped
    case cancelButtonTapped
    case confirmButtonTapped
    case applyImageFilters(Data)
    case setImage(Data?)
    case binding(BindingAction<State>)
  }

  let filters: [CIFilter] = [
    .sepiaTone(),
    .comicEffect(),
    .colorInvert(),
    .photoEffectFade(),
    .photoEffectMono(),
    .photoEffectTonal()
  ]

  @Dependency(\.dismiss) private var dismiss

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .textUpload:
        return .none

      case .textUploadButtonTapped:
        state.textUploadState = .init()
        return .none

      case .cancelButtonTapped:
        if state.textUploadState == nil {
          return .run { send in
            await dismiss()
          }

        } else {
          state.textUploadState = nil
          return .none
        }

      case .confirmButtonTapped:
        state.isPhotoLibraryPresented = true
        return .none

      case .binding(\.$selectedItem):
        guard let item = state.selectedItem else { return .none }

        return .run { send in
          let data = try await item.loadTransferable(type: Data.self)
          await send(.setImage(data))
        }

      case .binding:
        print("A")
        return .none

      case .setImage(let data):
        state.imageData = data ?? .init()
        return .none

      case .applyImageFilters(let imageData):
        state.filteredImage = applyFilters(imageData)
        print(state.filteredImage)
        return .none
      }
    }
    .ifLet(\.$textUploadState, action: /Action.textUpload) {
      TextUploadCore()
    }
  }

  private func applyFilters(_ data: Data) -> [FilteredImage] {
    let context = CIContext()
    var images = [FilteredImage]()

    filters.forEach { imageFilter in
      let ciImage = CIImage(data: data)
      imageFilter.setValue(ciImage, forKey: kCIInputImageKey)

      guard let newImage = imageFilter.outputImage else { return }
      guard let cgImage = context.createCGImage(newImage, from: newImage.extent) else { return }

      let filteredImage = FilteredImage(image: .init(cgImage: cgImage), filter: imageFilter)
      images.append(filteredImage)
    }

    return images
  }
}

