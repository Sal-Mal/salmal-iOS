import UIKit

import ComposableArchitecture

public final class SMToastManager {
  var keyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }.first
  }

  @MainActor
  public func showToast(_ toast: SMToast, duration: TimeInterval = 3.0) {
    guard let keyWindow else {
      return debugPrint("Key window가 없습니다")
    }
    
    if let removeTarget = keyWindow.subviews.first(where: { $0 is SMToastView }) {
      removeTarget.removeFromSuperview()
    }
    
    let toastView = SMToastView(toast: toast)
    toastView.translatesAutoresizingMaskIntoConstraints = false
    toastView.alpha = 0
    
    keyWindow.addSubview(toastView)
    toastView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
    toastView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor, constant: -40).isActive = true
    
    UIView.animate(withDuration: 0.5) {
      toastView.alpha = 1
    } completion: { finished in
      
      guard finished else { return }
      UIView.animate(withDuration: 1, delay: 2) {
        toastView.alpha = 0
        
      } completion: { finished in
        guard finished else { return }
        
        toastView.removeFromSuperview()
      }
    }
  }
}

/// TCA DependencyKey를 정의
public enum SMToastManagerKey: DependencyKey {
  public static let liveValue = SMToastManager()
  public static let previewValue = SMToastManager()
  public static let testValue = SMToastManager()
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var toastManager: SMToastManager {
    get { self[SMToastManagerKey.self] }
    set { self[SMToastManagerKey.self] = newValue }
  }
}
