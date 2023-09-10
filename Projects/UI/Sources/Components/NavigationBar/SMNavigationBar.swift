import SwiftUI

public extension View {
  // title, color 형태를 고정한 매서드
  func smNavigationBar(
    title: String,
    @ViewBuilder leftItems: @escaping () -> some View,
    @ViewBuilder rightItems: @escaping () -> some View,
    color: Color = .ds(.black)
  ) -> some View {
    modifier(SMNavigationBar(
      leftItems: leftItems,
      rightItems: rightItems,
      title: { Text(title)

        .font(.title2)
        .foregroundColor(.ds(.white))
      },
      color: color
    ))
  }
  
  // 가장 일반적인 매서드
  func smNavigationBar(
    @ViewBuilder _ lefts: @escaping () -> some View,
    @ViewBuilder _ rights: @escaping () -> some View,
    @ViewBuilder _ title: @escaping () -> some View,
    _ color: Color
  ) -> some View {
    modifier(
      SMNavigationBar(leftItems: lefts, rightItems: lefts, title: lefts, color: color)
    )
  }
}

public struct SMNavigationBar<L, C, R>: ViewModifier where L: View, C: View, R: View {
  
  let leftItems: () -> L
  let rightItems: () -> R
  let title: () -> C
  let color: Color
  
  public init(
    @ViewBuilder leftItems: @escaping () -> L,
    @ViewBuilder rightItems: @escaping () -> R,
    @ViewBuilder title: @escaping () -> C,
    color: Color
  ) {
    self.leftItems = leftItems
    self.rightItems = rightItems
    self.title = title
    self.color = color
  }
  
  public func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .principal, content: title)
        ToolbarItem(placement: .navigationBarLeading, content: leftItems)
        ToolbarItem(placement: .navigationBarTrailing, content: rightItems)
      }
      .toolbarBackground(color, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
  }
}
