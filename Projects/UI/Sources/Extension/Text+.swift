import SwiftUI

/// NavigationItem을 편하게 만들기 위함
public extension Text {
  func navigationItem(color: Color = .ds(.white)) -> some View {
    self
      .foregroundColor(color)
      .font(.ds(.title2))
  }
}
