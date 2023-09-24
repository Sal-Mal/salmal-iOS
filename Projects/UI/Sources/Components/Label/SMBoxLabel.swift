import SwiftUI

public struct SMBoxLabel: View {

  // 상태
  // - Disabled
  // - Loading -> 보류!

  // Corner Radius
  // - 기본 Box (커스텀 Radius)
  // - Round Box (높이 50%)

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
        return .pretendard(.medium, size: 11)
      case .medium:
        return .pretendard(.semiBold, size: 13)
      case .large:
        return .pretendard(.semiBold, size: 16)
      case .xLarge:
        return .pretendard(.semiBold, size: 20)
      }
    }
  }

  public enum ButtonRadius {
    case half
    case custom(CGFloat)
  }

  @Environment(\.isEnabled) private var isEnabled: Bool

  /// 버튼 텍스트
  private let title: String

  /// 버튼 텍스트 (small, medium, large[default], xLarge)
  private let buttonSize: ButtonSize

  /// 버튼 CornerRadius (커스텀, half(높이의 절반))
  private let buttonRadius: ButtonRadius

  private let foregroundColor: Color
  private let backgroundColor: Color

  /// 버튼 텍스트 색상
  private var _foregroundColor: Color {
    return isEnabled ? foregroundColor : .ds(.gray3)
  }

  /// 버튼 배경색 색상
  private var _backgroundColor: Color {
    return isEnabled ? backgroundColor : .ds(.gray2)
  }

  public init(
    title: String,
    buttonSize: ButtonSize = .large,
    buttonRadius: ButtonRadius = .half,
    foregroundColor: Color = .ds(.black),
    backgroundColor: Color = .ds(.green1)
  ) {
    self.title = title
    self.buttonSize = buttonSize
    self.buttonRadius = buttonRadius
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
  }

  public var body: some View {
    Text(title)
      .foregroundColor(_foregroundColor)
      .font(buttonSize.font)
      .frame(maxWidth: .infinity)
      .frame(height: buttonSize.height)
      .background {
        RoundedRectangle(cornerRadius: setRadius())
          .fill(_backgroundColor)
      }
      .animation(.default, value: _backgroundColor)
  }

  private func setRadius() -> CGFloat {
    switch buttonRadius {
    case .half:
      return buttonSize.height / 2

    case .custom(let radius):
      return radius
    }
  }
}
