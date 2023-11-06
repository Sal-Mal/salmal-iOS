import UIKit
import ComposableArchitecture
import CoreImage.CIFilterBuiltins
import SwiftUI

import Core

struct TextInformation: Equatable {
  let text: String
  let font: Font?
  let foregroundColor: Color?
  let backgroundColor: Color?
}

public struct PhotoEditorCore: Reducer {

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    @BindingState var isChanging: Bool = false
    @BindingState var isHovering: Bool = false

    var image: UIImage?
    var originalImage: UIImage?
    var filteredImage: [FilteredImage] = []
    var photoTextBoxes: IdentifiedArrayOf<PhotoTextBox> = []

    public init(uiImage: UIImage?) {
      self.image = uiImage
      self.originalImage = uiImage
    }
  }

  public enum Action: BindableAction {
    case backButtonTapped
    case confirmButtonTapped(any View)
    case addTextButtonTapped
    case filteredImageSelected(FilteredImage)
    case textBoxDeleteAreaEntered(PhotoTextBox)
    case textBoxOffsetChanged(PhotoTextBox, offset: CGSize)
    case textBoxOffsetEnded(PhotoTextBox, offset: CGSize)
    case textBoxOffsetHovering(PhotoTextBox, isHovering: Bool)

    case _onAppear

    case delegate(Delegate)
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)

    public enum Delegate {
      case savePhoto
    }
  }

  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.voteRepository) private var voteRepository

  private let filters: [CIFilter] = [
    .photoEffectFade(),
    .photoEffectMono(),
    .photoEffectTonal(),
    .sepiaTone(),
    .comicEffect(),
    .colorInvert()
  ]

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        switch state.destination {
        case .photoTextEditor:
          state.destination = nil
          return .none

        default:
          return .run { send in
            await dismiss()
          }
        }

      case .confirmButtonTapped(let photoView):
        switch state.destination {
        case .photoTextEditor(let textEditorState):
          let newTextBox = PhotoTextBox(
            text: textEditorState.text,
            font: textEditorState.font,
            textColor: textEditorState.foregroundColor,
            backgroundColor: textEditorState.backgroundColor
          )

          state.photoTextBoxes.append(newTextBox)
          state.destination = nil
          return .none

        default:
          let uiImage = photoView.snapshot()
          guard let data = uiImage.jpegData(compressionQuality: 1) else {
            return .none
          }

          return .run { send in
            try await voteRepository.register(data: data)
            await send(.delegate(.savePhoto))
            await dismiss()
          } catch: { error, send in
            print(error)
            await dismiss()
          }
        }

      case .addTextButtonTapped:
        state.destination = .photoTextEditor(.init())
        return .none

      case .filteredImageSelected(let filteredImage):
        state.image = filteredImage.image
        return .none

      case .textBoxDeleteAreaEntered(let textBox):
        guard let index = state.photoTextBoxes.firstIndex(where: { $0.id == textBox.id }) else {
          return .none
        }
        state.photoTextBoxes[index].offset = .zero
        state.photoTextBoxes[index].lastOffset = .zero
        state.photoTextBoxes.remove(at: index)
        return .none

      case .textBoxOffsetChanged(let textBox, let offset):
        guard let index = state.photoTextBoxes.firstIndex(where: { $0.id == textBox.id }) else {
          return .none
        }
        state.photoTextBoxes[index].offset = offset
        return .none

      case .textBoxOffsetEnded(let textBox, let offset):
        guard let index = state.photoTextBoxes.firstIndex(where: { $0.id == textBox.id }) else {
          return .none
        }
        state.photoTextBoxes[index].lastOffset = offset
        return .none

      case .textBoxOffsetHovering(let textBox, let isHovering):
        guard let index = state.photoTextBoxes.firstIndex(where: { $0.id == textBox.id }) else {
          return .none
        }
        state.photoTextBoxes[index].isHovering = isHovering
        state.isHovering = !state.photoTextBoxes.allSatisfy { $0.isHovering == false }
        return .none

      case ._onAppear:
        guard let uiImage = state.image else { return .none }
        state.filteredImage = applyFilters(uiImage)
        return .none

      case .delegate:
        return .none

      case .binding:
        return .none

      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
  }

  public struct Destination: Reducer {
    public enum State: Equatable {
      case photoTextEditor(PhotoTextEditorCore.State)
    }

    public enum Action {
      case photoTextEditor(PhotoTextEditorCore.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
      Scope(state: /State.photoTextEditor, action: /Action.photoTextEditor) {
        PhotoTextEditorCore()
      }
    }
  }
}


// MARK: Photo Filter Helper

extension PhotoEditorCore {

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

    return [.init(image: image, filter: .bloom())] + images
  }
}
