import Foundation
import ComposableArchitecture
import PhotosUI

public final class PhotoService: NSObject {

  static let shared = PhotoService()
  private let imageManager = PHCachingImageManager()

  private override init() {}

  public func albums(
    size: CGSize,
    contentMode: PHImageContentMode = .aspectFit
  ) async -> [UIImage] {
    return await withCheckedContinuation { continuation in
      let fetchOptions = PHFetchOptions()
      fetchOptions.predicate = .init(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
      let fetchResult = PHAsset.fetchAssets(with: fetchOptions)

      guard fetchResult.count > 0 else {
        continuation.resume(returning: [])
        return
      }

      var assets = [PHAsset]()

      fetchResult.enumerateObjects { asset, index, pointer in
        guard index < fetchResult.count else {
          pointer.pointee = true
          return
        }

        assets.append(asset)
      }

      let group = DispatchGroup()
      var images = [UIImage]()

      assets.forEach { asset in
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = false
        options.deliveryMode = .highQualityFormat

        group.enter()

        imageManager.requestImage(for: asset, targetSize: size, contentMode: contentMode, options: options) { image, _ in
          guard let image else { return }

          images.append(image)
          group.leave()
        }
      }

      group.wait()

      group.notify(queue: .main) {
        continuation.resume(returning: images)
      }
    }
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
