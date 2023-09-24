import SwiftUI

public struct SMFloatingActionButton: View {

  public enum ButtonSize {
    case small
    case medium
    case large

    var height: CGFloat {
      switch self {
      case .small:
        return 32
      case .medium:
        return 42
      case .large:
        return 60
      }
    }

    var font: Font {
      switch self {
      case .small:
        return .ds(.title5)
      case .medium:
        return .ds(.title4(.semibold))
      case .large:
        return .ds(.title3(.semibold))
      }
    }
  }

  private let iconImage: Image
  private let buttonSize: ButtonSize
  private let badgeCount: Int
  private let backgroundColor: Color
  private let action: () -> Void

  private var badgeCountText: String {
    return "\(badgeCount > 999 ? "999+" : "\(badgeCount)")"
  }

  public init(
    iconImage: Image,
    buttonSize: ButtonSize = .medium,
    badgeCount: Int = 0,
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
      .clipShape(Capsule())
    }
    .overlay(alignment: .topTrailing) {
      if badgeCount > 0 {
        Text(badgeCountText)
          .foregroundColor(.ds(.gray3))
          .font(.ds(.title5))
          .padding(.horizontal, 6)
          .frame(height: 14)
          .background(Color.ds(.white))
          .clipShape(Capsule())
          .offset(x: 4 * CGFloat(badgeCountText.count), y: -3)
          .shadow(radius: 2)
      }
    }
  }
}

struct SMFloatingActionButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SMFloatingActionButton(
        iconImage: .init(icon: .messsage),
        buttonSize: .medium,
        backgroundColor: .gray
      ) {
        print("")
      }

      SMFloatingActionButton(
        iconImage: .init(icon: .messsage),
        buttonSize: .medium,
        badgeCount: 9999,
        backgroundColor: .black
      ) {
        print("")
      }
    }
  }
}
