import SwiftUI

public struct DragIndicator: View {
  let color: Color
  
  public init(color: Color = .ds(.white20)) {
    self.color = color
  }
  
  public var body: some View {
    Capsule()
      .foregroundColor(color)
      .frame(width: 39, height: 4)
      .padding(.top, 16)
  }
}

public struct SheetDragIndicator: View {
  let color: Color
  
  public init(color: Color = .ds(.gray3)) {
    self.color = color
  }
  
  public var body: some View {
    Rectangle().fill(color)
      .clipShape(Capsule())
      .frame(width: 39, height: 4)
  }
}

struct SheetDragIndicator_Previews: PreviewProvider {
  static var previews: some View {
    SheetDragIndicator()
  }
}
