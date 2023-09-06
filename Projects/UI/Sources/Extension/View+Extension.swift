import SwiftUI

extension View {

  func debug(_ color: Color = .red) -> some View {
    modifier(FrameDebugModifier(color: color))
  }

  public func toast(on toast: Binding<SMToast?>) -> some View {
    modifier(SMToastModifier(toast: toast))
  }
}
