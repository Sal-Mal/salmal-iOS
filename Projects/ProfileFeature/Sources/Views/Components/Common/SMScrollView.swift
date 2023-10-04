import SwiftUI

struct SMScrollViewPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct SMScrollView<Content: View>: View {

  let axis: Axis.Set
  let showIndicators: Bool
  let onChangedOffset: (CGPoint) -> Void
  let content: Content

  init(
    axis: Axis.Set = .vertical,
    showIndicators: Bool = true,
    onChangedOffset: @escaping (CGPoint) -> Void = { _ in },
    @ViewBuilder content: () -> Content
  ) {
    self.axis = axis
    self.showIndicators = showIndicators
    self.onChangedOffset = onChangedOffset
    self.content = content()
  }

  var body: some View {
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
    .onPreferenceChange(SMScrollViewPreferenceKey.self, perform: onChangedOffset)
  }
}
