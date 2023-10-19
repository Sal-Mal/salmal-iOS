import Foundation
import Combine

@MainActor
public class SMToastSwiftUIManager: ObservableObject {
  @Published public var toast: SMSwiftUIToast?

  public init() {}

  public func showToast(_ toast: SMSwiftUIToast?) {
    self.toast = toast
  }
}
