import SwiftUI

public extension SMCapsuleTextField {
  
  /**
   color 속성을 변경
   
   foreground, background, tinit, placeholder 변경가능
   */
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
  
  /**
   상단에 title 추가
   */
  func title(
    _ text: String,
    color: Color = .ds(.gray2),
    font: Font = .callout
  ) -> Self {
    var new = self
    new.title = text
    new.titleColor = color
    new.titleFont = font
    return new
  }
  
  /**
   왼쪽에 image 삽입
   */

  func leftImage(_ image: Image) -> Self {
    var new = self
    new.image = image
    return new
  }
  
  /**
   오른쪽에 button 생성
   
   button의 font, color는 각각 .font(), .color() 로 설정된 값을 따름
   */
  func rightButton(_ name: String, action: @escaping () -> Void) -> Self {
    var new = self
    new.buttonTitle = name
    new.buttonAction = action
    return new
  }
  
  /**
   font를 변경
   */
  func font(_ font: Font) -> Self {
    var new = self
    new.font = font
    return new
  }
  
  /**
   text의 limitLimit를 설정
   
   lineLimit > 1 이면 height가 flexible, scrollable 하게 동작
   */
  func lineLimit(_ num: Int) -> Self {
    var new = self
    new.lineLimit = num
    return new
  }
}

/**
 Capsule 모양의 TextField
 */
public struct SMCapsuleTextField: View {
  
  public enum Colors {
    case foreground(Color)
    case background(Color)
    case tint(Color)
    case placeholder(Color)
  }
  
  @Binding var text: String
  
  var title: String?
  var titleColor: Color = .ds(.gray2)
  var titleFont: Font = .callout
  
  var image: Image?
  var buttonTitle: String?
  var buttonAction: () -> Void = {}
  var lineLimit: Int = 1
  
  var textColor: Color = .ds(.white)
  var tintColor: Color = .ds(.green1)
  var font: Font = .body
  var bgColor: Color = .ds(.gray4)
  
  var placeholderColor: Color = .ds(.gray2)
  let placeholder: String
  
  @FocusState var focus: Bool
  
  public init(text: Binding<String>, placeholder: String = "") {
    self._text = text
    self.placeholder = placeholder
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      titleView
      
      HStack(alignment: .bottom, spacing: 8) {
        imageView
        
        HStack(alignment: .bottom) {
          textField
          
          if let buttonTitle {
            Spacer()
            Button {
              buttonAction()
              focus = false
            } label: {
              Text(buttonTitle)
                .foregroundColor(tintColor)
                .font(font)
                .padding([.top, .bottom, .trailing], 16)
                .frame(minHeight: 48)
            }
            .opacity(text.isEmpty ? 0 : 1)
            .animation(.default, value: text.isEmpty)
          }
        }
        .background(RoundedRectangle(cornerRadius: 24).fill(bgColor))
        .overlay(
          RoundedRectangle(cornerRadius: 24)
            .strokeBorder(focus ? tintColor : bgColor, lineWidth: 2)
            .animation(.default, value: focus)
        )
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
    if let image {
      image
        .resizable()
        .aspectRatio(1, contentMode: .fit)
        .frame(width: 54)
        .clipShape(Circle())
    }
  }
  
  @ViewBuilder
  var textField: some View {
    TextField(
      "",
      text: $text,
      prompt: Text(placeholder)
        .foregroundColor(placeholderColor)
        .font(font),
      axis: lineLimit > 1 ? .vertical : .horizontal
    )
    .focused($focus)
    .lineLimit(lineLimit)
    .font(font)
    .foregroundColor(textColor)
    .tint(tintColor)
    .padding([.top, .bottom, .leading], 16)
    .frame(minHeight: 48)
  }
}

struct SMCapsuleTextField_Previews: PreviewProvider {
  static var previews: some View {
    SMCapsuleTextField(text: .constant("ddsas"), placeholder: "눌러서 댓글입력")
      .color(.foreground(.ds(.white)))
      .color(.tint(.ds(.green1)))
      .leftImage(Image(icon: .ic_cancel))
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
