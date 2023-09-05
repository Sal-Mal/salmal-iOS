//
//  SMIconButton.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

public struct SMIconButton: View {

  public enum ButtonStyle {
    case white
    case black

    var forgroundColor: Color {
      switch self {
      case .white:
        return .ds(.black)

      case .black:
        return .ds(.white)
      }
    }

    var backgroundColor: Color {
      switch self {
      case .white:
        return .ds(.white)

      case .black:
        return .ds(.black)
      }
    }
  }

  private let iconImage: Image
  private let buttonStyle: ButtonStyle
  private let caption: String?
  private let action: () -> Void

  public init(
    iconImage: Image,
    buttonStyle: ButtonStyle = .white,
    caption: String? = nil,
    action: @escaping () -> Void
  ) {
    self.iconImage = iconImage
    self.buttonStyle = buttonStyle
    self.caption = caption
    self.action = action
  }

  public var body: some View {
    Button {
      self.action()
    } label: {
      VStack(spacing: 2) {
        iconImage
          .resizable()
          .frame(width: 32, height: 32)

        if let caption {
          Text(caption)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(buttonStyle.forgroundColor)
        }
      }
    }
  }
}

struct SMIconButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SMIconButton(iconImage: .init(icon: .heart_fill)) {
        print("클릭")
      }

      SMIconButton(
        iconImage: .init(icon: .heart_fill),
        caption: "좋아요"
      ) {
        print("클릭")
      }

      SMIconButton(
        iconImage: .init(icon: .camera),
        buttonStyle: .black
      ) {
        print("클릭")
      }
      .preferredColorScheme(.dark)

      SMIconButton(
        iconImage: .init(icon: .camera),
        buttonStyle: .black,
        caption: "촬영"
      ) {
        print("클릭")
      }
      .preferredColorScheme(.dark)
    }
  }
}
