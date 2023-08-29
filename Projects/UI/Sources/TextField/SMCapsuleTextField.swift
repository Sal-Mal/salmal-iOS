import SwiftUI

public extension SMCapsuleTextField {
  
  func color(_ colors: Self.Colors) -> Self {
    var new = self
    
    switch colors {
    case let .foreground(color):
      new.textColor = color
    case let .background(color):
      new.bgColor = color
    case let .tint(color):
      new.tintColor = color
    }
    
    return new
  }
  
  func title(
    _ text: String,
    color: Color =  UIAsset.gray2.swiftUIColor,
    font: Font = .callout
  ) -> Self {
    var new = self
    new.title = text
    new.titleColor = color
    new.titleFont = font
    return new
  }
  
  func font(_ font: Font) -> Self {
    var new = self
    new.font = font
    return new
  }
}

public struct SMCapsuleTextField: View {
  
  public enum Colors {
    case foreground(Color)
    case background(Color)
    case tint(Color)
  }
  
  @Binding var text: String
  
  var title: String?
  var titleColor: Color = UIAsset.gray2.swiftUIColor
  var titleFont: Font = .callout
  
  var textColor: Color = UIAsset.white.swiftUIColor
  var tintColor: Color = UIAsset.green1.swiftUIColor
  var font: Font = .body
  var bgColor: Color = UIAsset.gray4.swiftUIColor
  
  @FocusState var focus: Bool
  
  public init(
    text: Binding<String>
  ) {
    self._text = text
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      if let title {
        Text(title)
          .foregroundColor(titleColor)
          .font(titleFont)
      }
      TextField("", text: $text)
        .focused($focus)
        .font(font)
        .foregroundColor(textColor)
        .tint(tintColor)
        .padding()
        .frame(height: 48)
        .background(Capsule().fill(bgColor))
        .overlay(
          Capsule().strokeBorder(focus ? tintColor : bgColor, lineWidth: 2)
            .animation(.default, value: focus)
        )
    }
  }
}

struct SMTextField_Previews: PreviewProvider {
  static var previews: some View {
    SMCapsuleTextField(text: .constant("dd"))
      .color(.foreground(UIAsset.white.swiftUIColor))
      .color(.tint(UIAsset.green1.swiftUIColor))
      .title("닉네임")
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
