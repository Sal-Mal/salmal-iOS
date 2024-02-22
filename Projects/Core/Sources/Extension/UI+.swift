import UIKit

public extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

extension UINavigationController: UIGestureRecognizerDelegate {
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestyreRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
