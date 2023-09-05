//
//  SMBoxButton.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

public struct SMBoxButton: View {

  // 상태
  // - Disabled
  // - Loading -> 보류!

  // 버튼 타입
  // - filled(default)
  // - outlined

  // Corner Radius
  // - 기본 Box (r6)
  // - Round Box (높이 50%)

  public enum ButtonType {
    case filled
    case outlined
  }

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

  public enum ButtonRadius {
    case r6
    case half
  }

  @Environment(\.isEnabled) private var isEnabled: Bool

  /// 버튼 텍스트 색상
  private var foregroundColor: Color {
    if isEnabled {
      if buttonType == .filled {
        return .ds(.black)
      } else {
        return .ds(.green1)
      }
    } else {
      if buttonType == .filled {
        return .ds(.gray3)
      } else {
        return .ds(.gray2)
      }
    }
  }

  /// 버튼 배경색 색상
  private var backgroundColor: Color {
    if isEnabled {
      return .ds(.green1)
    } else {
      return .ds(.gray1)
    }
  }

  /// 버튼 텍스트
  private let title: String

  /// 버튼 타입 (filled[default], outlined)
  private let buttonType: ButtonType

  /// 버튼 텍스트 (small, medium, large[default], xLarge)
  private let buttonSize: ButtonSize

  /// 버튼 CornerRadius (r6, half(높이의 절반))
  private let buttonRadius: ButtonRadius

  /// 버튼 액션
  private let action: () -> Void

  public init(
    title: String,
    buttonType: ButtonType = .filled,
    buttonSize: ButtonSize = .xLarge,
    buttonRadius: ButtonRadius = .half,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.buttonType = buttonType
    self.buttonSize = buttonSize
    self.buttonRadius = buttonRadius
    self.action = action
  }

  public var body: some View {
    Button {
      self.action()
    } label: {
      Text(title)
        .foregroundColor(foregroundColor)
        .font(buttonSize.font)
        .frame(maxWidth: .infinity)
        .frame(height: buttonSize.height)
        .background {
          if buttonType == .filled {
            RoundedRectangle(cornerRadius: setRadius())
              .fill(backgroundColor)
          } else {
            RoundedRectangle(cornerRadius: setRadius())
              .stroke(lineWidth: 2)
              .fill(backgroundColor)
          }
        }
    }
  }

  private func setRadius() -> CGFloat {
    switch buttonRadius {
    case .r6:
      return 6

    case .half:
      return buttonSize.height / 2
    }
  }
}

struct SMBoxButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SMBoxButton(title: "확인") {
        print("확인 클릭")
      }
      .disabled(false)
      .padding()
      .preferredColorScheme(.dark)
      .previewDisplayName("Filled Button")
      .previewLayout(.sizeThatFits)

      SMBoxButton(title: "확인", buttonRadius: .r6) {
        print("확인 클릭")
      }
      .disabled(false)
      .padding()
      .preferredColorScheme(.dark)
      .previewDisplayName("Filled Button Radius 6")
      .previewLayout(.sizeThatFits)

      SMBoxButton(title: "확인") {
        print("확인 클릭")
      }
      .disabled(true)
      .padding()
      .preferredColorScheme(.dark)
      .previewDisplayName("Filled Button: Disabled")
      .previewLayout(.sizeThatFits)

      SMBoxButton(title: "확인", buttonType: .outlined) {
        print("확인 클릭")
      }
      .environment(\.isEnabled, true)
      .padding()
      .preferredColorScheme(.dark)
      .previewDisplayName("Outlined Button")
      .previewLayout(.sizeThatFits)

      SMBoxButton(title: "확인", buttonType: .outlined) {
        print("확인 클릭")
      }
      .environment(\.isEnabled, false)
      .padding()
      .preferredColorScheme(.dark)
      .previewDisplayName("Outlined Button: Disabled")
      .previewLayout(.sizeThatFits)
    }
  }
}
