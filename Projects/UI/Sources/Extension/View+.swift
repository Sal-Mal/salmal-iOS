import SwiftUI

public extension View {
  func debug(_ color: Color = .red) -> some View {
    modifier(FrameDebugModifier(color: color))
  }

  func toast(on toast: Binding<SMSwiftUIToast?>) -> some View {
    modifier(SMToastSwiftUIModifier(toast: toast))
  }
}
