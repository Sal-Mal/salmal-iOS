//
//  SMCapsuleButton.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

public struct SMCapsuleButton: View {

  public enum ButtonStyle {
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

  /// 버튼 텍스트
  private let title: String

  /// 버튼 좌측 아이콘 이미지 (Optional)
  private let iconImage: Image?

  /// 버튼 스타일 (white, black)
  private let buttonMode: ButtonStyle

  /// 버튼 액션
  private let action: () -> Void

  public init(
    title: String,
    iconImage: Image? = nil,
    buttonMode: ButtonStyle = .white,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.iconImage = iconImage
    self.buttonMode = buttonMode
    self.action = action
  }
  
  public var body: some View {
    Button {
      self.action()
    } label: {
      HStack(spacing: 2) {
        if let image = iconImage {
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32, height: 32)
            .clipShape(Circle())
        }
        Text(title)
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(buttonMode.forgroundColor)
      }
      .frame(height: 44)
      .padding(.horizontal, 10)
      .background(buttonMode.backgroundColor)
      .clipShape(Capsule())
    }
  }
}

struct SMCapsuleButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SMCapsuleButton(title: "feroldis") {
        print("SMCapsuleButton 클릭")
      }
      .preferredColorScheme(.dark)
      .previewDisplayName("SMCapsuleButton")
      .previewLayout(.sizeThatFits)

      SMCapsuleButton(
        title: "feroldis",
        iconImage: UIAsset.heartFill.swiftUIImage
      ) {
        print("SMCapsuleButton 클릭")
      }
      .preferredColorScheme(.dark)
      .previewDisplayName("SMCapsuleButton: Icon")
      .previewLayout(.sizeThatFits)

      SMCapsuleButton(
        title: "feroldis",
        iconImage: UIAsset.camera.swiftUIImage,
        buttonMode: .black
      ) {
        print("SMCapsuleButton 클릭")
      }
      .preferredColorScheme(.light)
      .previewDisplayName("SMCapsuleButton: Dark")
      .previewLayout(.sizeThatFits)
    }
  }
}
