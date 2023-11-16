import Foundation
import SwiftUI
import PhotosUI
import ComposableArchitecture

public final class PhotoService: NSObject {

  private enum Constant {
    static let scale = UIScreen.main.scale
  }

  static let shared = PhotoService()
  private let cachingImageManager = PHCachingImageManager()

  private override init() {}

  public func requestAuthorization() async throws {
    let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)

    switch status {
    case .authorized, .limited:
      return

    default:
      throw SMError.authorization(reason: .photoLibrary)
    }
  }

  public func albums(
    size: CGSize = .init(width: 100, height: 100),
    contentMode: PHImageContentMode = .aspectFit
  ) async throws -> [UIImage] {
    cachingImageManager.allowsCachingHighQualityImages = false

    let fetchOptions = PHFetchOptions()
    fetchOptions.includeHiddenAssets = false
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    guard fetchResult.countOfAssets(with: .image) > .zero else { return [] }

    var assets = [PHAsset]()
    fetchResult.enumerateObjects { asset, index, pointer in
      guard index < fetchResult.count else {
        pointer.pointee = true
        return
      }
      assets.append(asset)
    }

    let targetSize = CGSize(width: size.width * Constant.scale, height: size.height * Constant.scale)

    return try assets.map { asset in
      return try fetchImage(for: asset, targetSize: targetSize, contentMode: contentMode)
    }
  }

  public func exportCompressedImage(_ uiImage: UIImage) -> Data {
    let maximumImageDataBytesCount = 1_000_000 // 3MB

    var data = Data()
    for quality in stride(from: 1.0, to: 0, by: -0.1) {
      guard let imageData = uiImage.jpegData(compressionQuality: quality) else { break }

      let bytes = imageData.count
      if bytes <= maximumImageDataBytesCount {
        data = imageData
        break
      }
    }
    return data
  }

  private func fetchImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) throws -> UIImage {
    let options = PHImageRequestOptions()
    options.isNetworkAccessAllowed = false
    options.isSynchronous = true
    options.resizeMode = .fast

    var image: UIImage?
    cachingImageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { result, _ in
      image = result
    }

    guard let image else { throw SMError.authorization(reason: .photoLibrary) }
    return image
  }
}


public enum PhotoServiceKey: DependencyKey {
  public static var liveValue: PhotoService {
    return .shared
  }
}

public extension DependencyValues {

  var photoService: PhotoService {
    get { self[PhotoServiceKey.self] }
    set { self[PhotoServiceKey.self] = newValue }
  }
}

extension View {

  public func snapshot() -> UIImage {
    let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
    let view = controller.view
    let targetSize = controller.view.intrinsicContentSize
    let aspectRatio = targetSize.height / targetSize.width
    let imageSizeWidth = UIScreen.main.bounds.width - 32
    let imageSizeHeight = floor(imageSizeWidth * aspectRatio)
    let imageSize = CGSize(width: imageSizeWidth, height: imageSizeHeight)

    view?.bounds = CGRect(origin: .zero, size: imageSize)
    view?.backgroundColor = .clear

    let renderer = UIGraphicsImageRenderer(size: imageSize)
    return renderer.image { _ in
      view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
  }
}
