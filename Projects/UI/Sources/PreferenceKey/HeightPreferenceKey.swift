import SwiftUI

/// View의 Size를 알아내기위한 PreferenceKey
struct HeightPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat?
  
  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
    guard let nextValue = nextValue() else { return }
    value = nextValue
  }
}

struct ReadHeightModifier: ViewModifier {
  func body(content: Content) -> some View {
    content.background(
      GeometryReader { proxy in
        Color.clear.preference(key: HeightPreferenceKey.self, value: proxy.size.height)
      }
    )
  }
}

public extension View {
  /**
   해당 modifier와 onPreferenceChange modifier를 사용해서 프로퍼티에 Height값을 전달
   */
  func readHeight() -> some View {
    self.modifier(ReadHeightModifier())
  }
}
