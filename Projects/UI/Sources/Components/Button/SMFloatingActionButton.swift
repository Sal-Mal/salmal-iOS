//
//  SMFloatingActionButton.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

public struct SMFloatingActionButton: View {

  public enum ButtonSize {
    case small
    case medium
    case large
    case xLarge

    var height: CGFloat {
      switch self {
      case .small:
        return 32
      case .medium:
        return 48
      case .large:
        return 55
      case .xLarge:
        return 60
      }
    }

    var font: Font {
      switch self {
      case .small:
        return .system(size: 11, weight: .medium)
      case .medium:
        return .system(size: 13, weight: .semibold)
      case .large:
        return .system(size: 16, weight: .semibold)
      case .xLarge:
        return .system(size: 20, weight: .bold)
      }
    }
  }

  private let iconImage: Image
  private let buttonSize: ButtonSize
  private let badgeCount: Int?
  private let backgroundColor: Color
  private let action: () -> Void

  public init(
    iconImage: Image,
    buttonSize: ButtonSize = .large ,
    badgeCount: Int? = nil,
    backgroundColor: Color,
    action: @escaping () -> Void
  ) {
    self.iconImage = iconImage
    self.buttonSize = buttonSize
    self.badgeCount = badgeCount
    self.backgroundColor = backgroundColor
    self.action = action
  }

  public var body: some View {
    Button {
      self.action()
    } label: {
      ZStack {
        iconImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24, height: 24)
      }
      .frame(
        width: buttonSize.height,
        height: buttonSize.height
      )
      .background(backgroundColor)
      .cornerRadius(buttonSize.height / 2)
    }
    .overlay(alignment: .topTrailing) {
      if let badgeCount, buttonSize != .small {
        Text("\(badgeCount)")
          .foregroundColor(.black)
          .font(.system(size: 13, weight: .regular))
          .padding(6)
          .frame(height: 21)
          .background(.white)
          .cornerRadius(10.5)
          .offset(x: 6)
          .shadow(radius: 1)
      }
    }
  }
}

struct SMFloatingActionButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SMFloatingActionButton(
        iconImage: .init(icon: .bookmark),
        buttonSize: .large,
        backgroundColor: .gray
      ) {
        print("")
      }

      SMFloatingActionButton(
        iconImage: .init(icon: .bookmark),
        buttonSize: .large,
        badgeCount: 15,
        backgroundColor: .black
      ) {
        print("")
      }
    }
  }
}
