import SwiftUI

public extension Image {
  init(icon: SM.Icon) {
    self.init(icon.rawValue, bundle: SM.bundle)
  }
}

/// 이미지를 편하게 만들기 위함
public extension Image {
  @ViewBuilder
  func fit(
    size: CGFloat? = nil,
    renderingMode: TemplateRenderingMode = .original,
    color: Color = .ds(.white)
  ) -> some View {
    
    if let size {
      self.resizable()
        .renderingMode(renderingMode)
        .aspectRatio(1, contentMode: .fit)
        .frame(width: size, height: size)
        .foregroundColor(color)
    } else {
      self.resizable()
        .renderingMode(renderingMode)
        .aspectRatio(1, contentMode: .fit)
        .foregroundColor(color)
    }
  }
  
  @ViewBuilder
  func fill(
    size: CGFloat? = nil,
    renderingMode: TemplateRenderingMode = .original,
    color: Color = .ds(.white)
  ) -> some View {
    if let size {
      self.resizable()
        .renderingMode(renderingMode)
        .aspectRatio(1, contentMode: .fill)
        .frame(width: size, height: size)
        .foregroundColor(color)
    } else {
      self.resizable()
        .renderingMode(renderingMode)
        .aspectRatio(1, contentMode: .fill)
        .foregroundColor(color)
    }
  }
}
