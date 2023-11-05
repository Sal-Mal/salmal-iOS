import SwiftUI
import UI

public struct TabView: View {
  @State var tabIndex: TabItem = .home
  @State var isPresented = false
  
  public var body: some View {
    VStack {
      switch tabIndex {
      case .home:
        Rectangle().fill(.blue)
      case .profile:
        Rectangle().fill(.red)
      }
      
      Spacer()
      SalMalTabBar(tabIndex: $tabIndex) {
        isPresented = true
      }
    }
    .sheet(isPresented: $isPresented) {
      Rectangle().fill(.green)
    }
  }
}

#Preview {
  TabView()
    .preferredColorScheme(.dark)
}
