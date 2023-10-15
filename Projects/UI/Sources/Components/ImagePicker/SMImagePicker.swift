import SwiftUI

public struct SMImagePicker: UIViewControllerRepresentable {

  public typealias UIViewControllerType = UIImagePickerController

  private let onCapture: (Data?) -> Void
  private let onDismiss: () -> Void

  public init(onCapture: @escaping (Data?) -> Void, onDismiss: @escaping () -> Void) {
    self.onCapture = onCapture
    self.onDismiss = onDismiss
  }

  public func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .camera
    imagePicker.delegate = context.coordinator

    return imagePicker
  }

  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

  public func makeCoordinator() -> Coordinator {
    Coordinator(delegate: self)
  }


  // MARK: - Coordinator (Delegate)

  public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let delegate: SMImagePicker

    init(delegate: SMImagePicker) {
      self.delegate = delegate
    }

    public func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
      guard let image = info[.originalImage] as? UIImage else {
        delegate.onDismiss()
        return
      }

      delegate.onCapture(image.jpegData(compressionQuality: 0.1))
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      delegate.onDismiss()
    }
  }
}
