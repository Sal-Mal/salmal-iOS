import SwiftUI

struct SMScrollViewPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

public struct SMScrollView<Content: View>: View {

  private let axis: Axis.Set
  private let showIndicators: Bool
  @Binding private var onOffsetChanged: CGPoint
  private let content: Content

  public init(
    axis: Axis.Set = .vertical,
    showIndicators: Bool = true,
    onOffsetChanged: Binding<CGPoint>,
    @ViewBuilder content: () -> Content
  ) {
    self.axis = axis
    self.showIndicators = showIndicators
    self._onOffsetChanged = onOffsetChanged
    self.content = content()
  }

  public var body: some View {
    ScrollView(axis, showsIndicators: showIndicators) {
      GeometryReader { proxy in
        Color.clear.preference(
          key: SMScrollViewPreferenceKey.self,
          value: proxy.frame(in: .named("SMScrollView")).origin
        )
      }
      .frame(width: 0, height: 0)
      content
    }
    .coordinateSpace(name: "SMScrollView")
    .onPreferenceChange(SMScrollViewPreferenceKey.self) { point in
      onOffsetChanged = point
    }
    .scrollIndicators(.hidden)
  }
}
