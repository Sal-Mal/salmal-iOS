import UIKit
import ComposableArchitecture
import CoreImage.CIFilterBuiltins

import Core

public struct UploadEditingPhotoCore: Reducer {

  public struct State: Equatable {

    @PresentationState var uploadEditingTextState: UploadEditingTextCore.State?
    var image: UIImage?
    var originalImage: UIImage?
    var filteredImage: [FilteredImage] = []

    public init(image: UIImage?) {
      self.image = image
      self.originalImage = image
    }
  }

  public enum Action {
    case onAppear
    case backButtonTapped
    case confirmButtonTapped
    case uploadEditingTextButtonTapped
    case uploadEditingText(PresentationAction<UploadEditingTextCore.Action>)
    case filteredImageSelected(FilteredImage)
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
    Reduce { state, action in
      switch action {
      case .onAppear:
        guard let image = state.image else { return .none }
        state.filteredImage = applyFilters(image)
        return .none

      case .uploadEditingTextButtonTapped:
        state.uploadEditingTextState = .init()
        return .none

      case .uploadEditingText:
        return .none

      case .backButtonTapped:
        guard state.uploadEditingTextState == nil else {
          state.uploadEditingTextState = nil
          return .none
        }

        return .run { send in
          await dismiss()
        }

      case .confirmButtonTapped:
        return .none

      case .filteredImageSelected(let filteredImage):
        state.image = filteredImage.image
        return .none
      }
    }
    .ifLet(\.$uploadEditingTextState, action: /Action.uploadEditingText) {
      UploadEditingTextCore()
    }
  }

  private func applyFilters(_ image: UIImage) -> [FilteredImage] {
    let context = CIContext()
    var images = [FilteredImage]()

    filters.forEach { imageFilter in
      let ciImage = CIImage(image: image)
      imageFilter.setValue(ciImage, forKey: kCIInputImageKey)

      guard let newImage = imageFilter.outputImage else { return }
      guard let cgImage = context.createCGImage(newImage, from: newImage.extent) else { return }

      let filteredImage = FilteredImage(image: .init(cgImage: cgImage), filter: imageFilter)
      images.append(filteredImage)
    }

    return images
  }
}

