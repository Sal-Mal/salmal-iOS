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
    case let .placeholder(color):
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
  
  func leftImage(_ name: String) -> Self {
    var new = self
    new.imageName = name
    return new
  }
  
  func font(_ font: Font) -> Self {
    var new = self
    new.font = font
    return new
  }
  
  func lineLimit(_ num: Int) -> Self {
    var new = self
    new.lineLimit = num
    return new
  }
}


public struct SMCapsuleTextField: View {
  
  public enum Colors {
    case foreground(Color)
    case background(Color)
    case tint(Color)
    case placeholder(Color)
  }
  
  @Binding var text: String
  
  var title: String?
  var titleColor: Color = UIAsset.gray2.swiftUIColor
  var titleFont: Font = .callout
  
  var imageName: String?
  var lineLimit: Int = 1
  
  var textColor: Color = UIAsset.white.swiftUIColor
  var tintColor: Color = UIAsset.green1.swiftUIColor
  var font: Font = .body
  var bgColor: Color = UIAsset.gray4.swiftUIColor
  
  var placeholderColor: Color = UIAsset.gray2.swiftUIColor
  let placeholder: String
  
  @FocusState var focus: Bool
  
  public init(text: Binding<String>, placeholder: String = "") {
    self._text = text
    self.placeholder = placeholder
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      titleView
      
      HStack(spacing: 8) {
        imageView
        
        if lineLimit >= 2 {
          flexibleTextField
        } else {
          fixedTextField
        }
      }
    }
  }
  
  @ViewBuilder
  var titleView: some View {
    if let title {
      Text(title)
        .foregroundColor(titleColor)
        .font(titleFont)
    }
  }
  
  @ViewBuilder
  var imageView: some View {
    if let imageName {
      Image(imageName, bundle: .module)
        .resizable()
        .scaledToFill()
        .frame(width: 48, height: 48)
        .clipShape(Circle())
    }
  }
  
  @ViewBuilder
  var fixedTextField: some View {
    TextField(
      "",
      text: $text,
      prompt: Text(placeholder)
        .foregroundColor(placeholderColor)
        .font(font)
    )
    .focused($focus)
    .lineLimit(lineLimit)
    .font(font)
    .foregroundColor(textColor)
    .tint(tintColor)
    .padding()
    .frame(minHeight: 48)
    .background(RoundedRectangle(cornerRadius: 24).fill(bgColor))
    .overlay(
      RoundedRectangle(cornerRadius: 24)
        .strokeBorder(focus ? tintColor : bgColor, lineWidth: 2)
        .animation(.default, value: focus)
    )
  }
  
  @ViewBuilder
  var flexibleTextField: some View {
    TextField(
      "",
      text: $text,
      prompt: Text(placeholder)
        .foregroundColor(placeholderColor)
        .font(font),
      axis: .vertical
    )
    .focused($focus)
    .lineLimit(lineLimit)
    .font(font)
    .foregroundColor(textColor)
    .tint(tintColor)
    .padding()
    .frame(minHeight: 48)
    .background(RoundedRectangle(cornerRadius: 24).fill(bgColor))
    .overlay(
      RoundedRectangle(cornerRadius: 24)
        .strokeBorder(focus ? tintColor : bgColor, lineWidth: 2)
        .animation(.default, value: focus)
    )
  }
}

struct SMCapsuleTextField_Previews: PreviewProvider {
  static var previews: some View {
    SMCapsuleTextField(text: .constant("ddsas"), placeholder: "눌러서 댓글입력")
      .color(.foreground(UIAsset.white.swiftUIColor))
      .color(.tint(UIAsset.green1.swiftUIColor))
      .leftImage(UIAsset.cancel.name)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
