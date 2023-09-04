import SwiftUI

extension Image {
  public init(icon: SM.Icon) {
    self.init(icon.rawValue, bundle: SM.bundle)
  }
}
