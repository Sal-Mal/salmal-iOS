import Foundation
import Combine

@MainActor
public class SMToastManager: ObservableObject {
  @Published public var toast: SMToast?

  public init() {}

  public func showToast(_ toast: SMToast?) {
    self.toast = toast
  }
}
