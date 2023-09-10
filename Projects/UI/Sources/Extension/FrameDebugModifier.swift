import SwiftUI

public struct FrameDebugModifier: ViewModifier {

  let color: Color

  public func body(content: Content) -> some View {
    content
    #if DEBUG
      .overlay(GeometryReader(content: overlay(for:)))
    #endif
  }

  private func overlay(for geometry: GeometryProxy) -> some View {
    ZStack(alignment: .topTrailing) {
      Rectangle()
        .strokeBorder(style: .init(lineWidth: 1, dash: [3]))
        .foregroundColor(color)

      Text("(\(Int(geometry.frame(in: .global).origin.x)), \(Int(geometry.frame(in: .global).origin.y))) \(Int(geometry.size.width))x\(Int(geometry.size.height))")
        .font(.caption2)
        .minimumScaleFactor(0.5)
        .foregroundColor(color)
        .padding(3)
        .offset(y: -20)
    }
  }
}
