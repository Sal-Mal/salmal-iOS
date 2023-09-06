import SwiftUI

public struct SheetDragIndicator: View {
  public var body: some View {
    Rectangle().fill(Color.ds(.gray3))
      .clipShape(Capsule())
      .frame(width: 39, height: 4)
      .padding(.top, 16)
  }
}

struct SheetDragIndicator_Previews: PreviewProvider {
  static var previews: some View {
    SheetDragIndicator()
  }
}
