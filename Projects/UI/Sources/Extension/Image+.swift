import SwiftUI
import UIKit

public extension Image {
  init(icon: SM.Icon) {
    self.init(icon.rawValue, bundle: SM.bundle)
  }
}

public extension UIImage {
  convenience init?(icon: SM.Icon) {
    self.init(named: icon.rawValue, in: SM.bundle, compatibleWith: nil)
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
        .scaledToFit()
        .frame(width: size, height: size)
        .foregroundColor(color)
    } else {
      self.resizable()
        .renderingMode(renderingMode)
        .scaledToFit()
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
        .scaledToFill()
        .frame(width: size, height: size)
        .foregroundColor(color)
    } else {
      self.resizable()
        .renderingMode(renderingMode)
        .scaledToFill()
        .foregroundColor(color)
    }
  }
}
