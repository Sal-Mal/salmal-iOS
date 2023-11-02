import SwiftUI

public struct SMNavigationView: View {
  private let title: String?
  private let leftIcon: Image?
  private let leftText: String?
  private let leftTextColor: Color?
  private let leftAction: () -> Void
  private let rightIcon: Image?
  private let rightText: String?
  private let rightTextColor: Color?
  private let rightAction: () -> Void

  public init(
    title: String? = nil,
    leftIcon: Image? = nil,
    leftText: String? = nil,
    leftTextColor: Color? = .ds(.white80),
    leftAction: @escaping () -> Void = {},
    rightIcon: Image? = nil,
    rightText: String? = nil,
    rightTextColor: Color? = .ds(.green1),
    rightAction: @escaping () -> Void = {}
  ) {
    self.title = title
    self.leftIcon = leftIcon
    self.leftText = leftText
    self.leftTextColor = leftTextColor
    self.leftAction = leftAction
    self.rightIcon = rightIcon
    self.rightText = rightText
    self.rightTextColor = rightTextColor
    self.rightAction = rightAction
  }
  
  public var body: some View {
    ZStack {
      HStack {
        SMBarButton(
          icon: leftIcon,
          text: leftText,
          textColor: leftTextColor,
          action: leftAction
        )

        Spacer()

        SMBarButton(
          icon: rightIcon,
          text: rightText,
          textColor: rightTextColor,
          action: rightAction
        )
      }

      if let title {
        HStack {
          Spacer()

          Text(title)
            .font(.ds(.title2(.semibold)))
            .foregroundColor(.ds(.white))

          Spacer()
        }
      }
    }
    .frame(height: 60, alignment: .center)
    .background(Color.ds(.black))
  }
}

private struct SMBarButton: View {
  private let icon: Image?
  private let text: String?
  private let textColor: Color?
  private let action: () -> Void

  init(
    icon: Image? = nil,
    text: String? = nil,
    textColor: Color? = nil,
    action: @escaping () -> Void = {}
  ) {
    self.icon = icon
    self.text = text
    self.textColor = textColor
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      HStack {
        if let icon {
          icon
            .frame(width: 32, height: 32, alignment: .center)
            .padding(8)
        }

        if let text {
          Text(text)
            .font(.ds(.title2(.semibold)))
            .foregroundColor(textColor)
        }
      }
    }
  }
}
