import UIKit

import ComposableArchitecture

/// Modal 띄울시, 뒷배경 dim 처리를 위한 매니저
public final class BlurManager {
  var keyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }.first
  }
  
  let blurView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    v.isUserInteractionEnabled = false
    return v
  }()
  
  public static let shared = BlurManager()
  
  public init() {}
  
  public func blurBackground() {
    guard let keyWindow else {
      return debugPrint("Key window가 없습니다")
    }
    
    if keyWindow.subviews.contains(blurView) {
      blurView.removeFromSuperview()
    }
    
    keyWindow.insertSubview(blurView, at: keyWindow.subviews.count - 1)
    blurView.frame = keyWindow.frame
    
    UIView.animate(withDuration: 0.1) {
      self.blurView.backgroundColor = .ds(.black).withAlphaComponent(0.4)
    }
  }
  
  public func clearBackground() {
    UIView.animate(withDuration: 0.1) {
      self.blurView.backgroundColor = .clear
    } completion: { _ in
      self.blurView.removeFromSuperview()
    }
  }
}

/// TCA DependencyKey를 정의
public enum BlurManagerKey: DependencyKey {
  public static let liveValue = BlurManager()
  public static let previewValue = BlurManager()
  public static let testValue = BlurManager()
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var blurManager: BlurManager {
    get { self[BlurManagerKey.self] }
    set { self[BlurManagerKey.self] = newValue }
  }
}
