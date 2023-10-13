import Foundation
import Combine

import ComposableArchitecture

@MainActor
public class SMToastManager: ObservableObject {
  @Published public var toast: SMToast?

  private init() {}
  public static let shared = SMToastManager()

  public func showToast(_ toast: SMToast?) {
    self.toast = toast
  }
}

/// TCA DependencyKey를 정의
public enum ToastManagerKey: DependencyKey {
  public static let liveValue: SMToastManager = SMToastManager.shared
  public static let previewValue: SMToastManager = SMToastManager.shared
  public static let testValue: SMToastManager = SMToastManager.shared
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var toast: SMToastManager {
    get { self[ToastManagerKey.self] }
    set { self[ToastManagerKey.self] = newValue }
  }
}
