//
//  SMIconButton.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

public struct SMIconButton: View {

  private let iconImage: Image
  private let caption: String?
  private let foregroundColor: Color
  private let backgroundColor: Color
  private let action: () -> Void

  public init(
    iconImage: Image,
    caption: String? = nil,
    foregroundColor: Color = .ds(.black),
    backgroundColor: Color = .ds(.white),
    action: @escaping () -> Void
  ) {
    self.iconImage = iconImage
    self.caption = caption
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
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
            .font(.ds(.title4(.medium)))
            .foregroundColor(foregroundColor)
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
        iconImage: .init(icon: .camera)
      ) {
        print("클릭")
      }
      .preferredColorScheme(.dark)

      SMIconButton(
        iconImage: .init(icon: .camera),
        caption: "촬영",
        foregroundColor: .ds(.white)
      ) {
        print("클릭")
      }
      .preferredColorScheme(.dark)
    }
  }
}
