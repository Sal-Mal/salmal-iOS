import SwiftUI

extension View {

  func debug(_ color: Color = .red) -> some View {
    modifier(FrameDebugModifier(color: color))
  }
}
