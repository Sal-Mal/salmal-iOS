//
//  SMIconButton.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

struct SMIconButton: View {

  enum ButtonStyle {
    case white
    case black

    var forgroundColor: Color {
      switch self {
      case .white:
        return UIAsset.black.swiftUIColor

      case .black:
        return UIAsset.white.swiftUIColor
      }
    }

    var backgroundColor: Color {
      switch self {
      case .white:
        return UIAsset.white.swiftUIColor

      case .black:
        return UIAsset.black.swiftUIColor
      }
    }
  }

  private var iconImage: Image
  private var buttonStyle: ButtonStyle
  private var caption: String?
  private var action: () -> Void

  init(
    iconImage: Image,
    buttonStyle: ButtonStyle = .white,
    caption: String? = nil,
    action: @escaping () -> Void) {
    self.iconImage = iconImage
    self.buttonStyle = buttonStyle
    self.caption = caption
    self.action = action
  }

  var body: some View {
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
      SMIconButton(iconImage: UIAsset.heartFill.swiftUIImage) {
        print("클릭")
      }

      SMIconButton(
        iconImage: UIAsset.heartFill.swiftUIImage,
        caption: "좋아요"
      ) {
        print("클릭")
      }

      SMIconButton(
        iconImage: UIAsset.camera.swiftUIImage,
        buttonStyle: .black
      ) {
        print("클릭")
      }
      .preferredColorScheme(.dark)

      SMIconButton(
        iconImage: UIAsset.camera.swiftUIImage,
        buttonStyle: .black,
        caption: "촬영"
      ) {
        print("클릭")
      }
      .preferredColorScheme(.dark)
    }
  }
}
