import SwiftUI

extension Image {
  public init(icon: SM.Icon) {
    self.init(icon.rawValue, bundle: SM.bundle)
  }
}

/// 이미지를 편하게 만들기 위함
public extension Image {
  func fit(size: CGFloat, renderingMode: TemplateRenderingMode = .original, color: Color = .ds(.white)) -> some View {
    self.resizable()
      .renderingMode(renderingMode)
      .aspectRatio(1, contentMode: .fit)
      .frame(width: size, height: size)
      .foregroundColor(color)
  }
  
  func fill(size: CGFloat, renderingMode: TemplateRenderingMode = .original, color: Color = .ds(.white)) -> some View {
    self.resizable()
      .renderingMode(renderingMode)
      .aspectRatio(1, contentMode: .fill)
      .frame(width: size, height: size)
      .foregroundColor(color)
  }
}
