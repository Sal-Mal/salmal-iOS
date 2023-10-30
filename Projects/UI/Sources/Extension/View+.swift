import SwiftUI

public extension View {
  func debug(_ color: Color = .red) -> some View {
    modifier(FrameDebugModifier(color: color))
  }

  func synchronize<Value>(
    _ first: Binding<Value>,
    _ second: FocusState<Value>.Binding
  ) -> some View {
    self
      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
  }
}
