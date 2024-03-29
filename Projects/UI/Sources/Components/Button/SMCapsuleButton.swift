import SwiftUI

public struct SMCapsuleButton: View {

  /// 버튼 텍스트
  private let title: String

  /// 버튼 좌측 아이콘 이미지 (Optional)
  private let iconImage: Image?

  /// 버튼 비동기 이미지
  private let iconURL: URL?

  /// 버튼 ForegroundColor
  private let foregroundColor: Color

  /// 버튼 BackgroundColor
  private let backgroundColor: Color

  /// 버튼 액션
  private let action: () -> Void

  public init(
    title: String,
    iconImage: Image? = nil,
    foregroundColor: Color = .ds(.white),
    backgroundColor: Color = .ds(.black),
    action: @escaping () -> Void
  ) {
    self.title = title
    self.iconImage = iconImage
    self.iconURL = nil
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.action = action
  }

  public init(
    title: String,
    iconURL: URL,
    foregroundColor: Color = .ds(.white),
    backgroundColor: Color = .ds(.black),
    action: @escaping () -> Void
  ) {
    self.title = title
    self.iconImage = nil
    self.iconURL = iconURL
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.action = action
  }
  
  public var body: some View {
    Button {
      self.action()
    } label: {
      HStack(spacing: 8) {
        if let iconImage {
          iconImage
            .fill(size: 32)
            .clipShape(Circle())

        }
        
        if let iconURL {
          CacheAsyncImage(url: iconURL) { phase in
            if case let .success(image) = phase {
              image
                .fill(size: 32)
                .clipShape(Circle())
            }
          }
        }

        Text(title)
          .font(.ds(.title3(.medium)))
          .foregroundColor(foregroundColor)
      }
      .padding(.horizontal, 6)
      .frame(height: 44)
      .background(backgroundColor)
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
        iconImage: .init(icon: .ic_xmark)
      ) {
        print("SMCapsuleButton 클릭")
      }
      .preferredColorScheme(.dark)
      .previewDisplayName("SMCapsuleButton: Icon")
      .previewLayout(.sizeThatFits)

      /*
      SMCapsuleButton(title: "Button", iconURL: URL(string: "https://...")!) {
        print("SMCapsuleButton 클릭")
      }
      .preferredColorScheme(.dark)
      .previewDisplayName("SMCapsuleButton: 비동기")
      .previewLayout(.sizeThatFits)
       */

      SMCapsuleButton(
        title: "feroldis",
        iconImage: .init(icon: .bookmark_fill),
        foregroundColor: .white,
        backgroundColor: .blue
      ) {
        print("SMCapsuleButton 클릭")
      }
      .preferredColorScheme(.light)
      .previewDisplayName("SMCapsuleButton: Dark")
      .previewLayout(.sizeThatFits)
    }
  }
}
