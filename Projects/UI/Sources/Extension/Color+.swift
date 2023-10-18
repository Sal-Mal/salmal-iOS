import SwiftUI
import UIKit

extension Color {
  public static func ds(_ name: SM.Color) -> Color {
    return .init(name.rawValue, bundle: SM.bundle)
  }
}

extension UIColor {
  public static func ds(_ name: SM.Color) -> UIColor {
    UIColor(.ds(name))
  }
}
