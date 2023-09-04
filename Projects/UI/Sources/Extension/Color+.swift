import SwiftUI

extension Color {
  public static func ds(_ name: SM.Color) -> Color {
    return .init(name.rawValue, bundle: SM.bundle)
  }
}
