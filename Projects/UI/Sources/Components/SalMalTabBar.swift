import SwiftUI

/// CustomTabBar

public enum TabItem: Hashable {
  case home
  case profile
}

public struct SalMalTabBar: View {
  @Binding var tabIndex: TabItem
  let action: () -> Void
  
  public init(tabIndex: Binding<TabItem>, action: @escaping () -> Void) {
    self._tabIndex = tabIndex
    self.action = action
  }
  
  public var body: some View {
    VStack(spacing: .zero) {
      Color.ds(.white20).frame(height: 1)
      HStack {
        Image(icon : tabIndex == .home ? .home_fill : .home)
          .fill(size: 32)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .onTapGesture {
            tabIndex = .home
          }
        
        Image(icon: .ic_upload_circle)
          .fill(size: 32)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .onTapGesture {
            action()
          }
        
        Image(icon: tabIndex == .profile ? .person_fill : .person)
          .fill(size: 32)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .onTapGesture {
            tabIndex = .profile
          }
      }
      .frame(height: 52)
      .frame(maxWidth: .infinity)
    }
  }
}

struct SalMalTabBar_Preview: PreviewProvider {
  static var previews: some View {
    SalMalTabBar(tabIndex: .constant(.profile), action: {})
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
  }
}
