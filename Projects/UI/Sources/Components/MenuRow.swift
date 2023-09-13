import SwiftUI

public struct MenuItem: Equatable, Identifiable {
  public let id = UUID()
  
  let icon: Image
  let title: String
  
  public init(icon: Image, title: String) {
    self.icon = icon
    self.title = title
  }
}

/// image + title 형태의 Row
public struct MenuRow: View {
  let item: MenuItem
  
  public init(item: MenuItem) {
    self.item = item
  }
  
  public var body: some View {
    HStack(spacing: 6) {
      item.icon
        .renderingMode(.template)
        .resizable()
        .aspectRatio(1, contentMode: .fit)
        .frame(width: 32)
        .padding(.leading, 18)
      
      Text(item.title)
        .font(.ds(.title3))
    }
    .foregroundColor(.ds(.white))
    .frame(height: 60)
    .frame(maxWidth: .infinity, alignment: .leading)
    .contentShape(Rectangle())
  }
}

struct MenuRow_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black
      VStack {
        MenuRow(item: .init(icon: Image(icon: .warning), title: "해당 게시물 신고하기"))
        MenuRow(item: .init(icon: Image(icon: .warning), title: "해당 게시물 신고하기"))
      }
    }
  }
}
