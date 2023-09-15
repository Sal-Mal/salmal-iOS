import SwiftUI

/// 캐싱기능을 지원하는 AsyncImage
public struct CacheAsyncImage<Content: View>: View {
  let url: URL
  let scale: CGFloat
  let content: (AsyncImagePhase) -> Content
  
  private let cache = ImageCache.shared
  
  public init(
    url: URL,
    scale: CGFloat = 1.0,
    @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
  ) {
    self.url = url
    self.scale = scale
    self.content = content
  }
  
  public var body: some View {
    if let cachedImage = cache.value(forKey: url) {
      content(.success(cachedImage))
    } else {
      AsyncImage(url: url, scale: scale) { phase in
        image(phase)
      }
    }
  }
  
  private func image(_ phase: AsyncImagePhase) -> some View {
    if case let .success(image) = phase {
      cache.setValue(image, forKey: url)
    }
    
    return content(phase)
  }
}

/// 내부 이미지 캐시
private final class ImageCache {
  static let shared = ImageCache()
  private var cache = [URL: Image]()
  
  private init() { }
  
  func value(forKey key: URL) -> Image? {
    return cache[key]
  }
  
  func setValue(_ value: Image, forKey key: URL) {
    cache[key] = value
  }
}
