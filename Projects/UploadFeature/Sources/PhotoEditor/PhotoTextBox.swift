import SwiftUI

import UI

public struct PhotoTextBox: Equatable, Identifiable {
  public let id: String = UUID().uuidString
  var text: String = ""
  var font: Font = .ds(.title2(.medium))
  var textColor: Color = .ds(.white)
  var backgroundColor: Color = .clear
  var offset: CGSize = .zero
  var lastOffset: CGSize = .zero
  var isHovering: Bool = false
}
