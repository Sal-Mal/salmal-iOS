//
//  SMToastView.swift
//  UI
//
//  Created by 청새우 on 2023/09/06.
//

import SwiftUI

public struct SMToast: Equatable {
  let type: SMToastView.ToastType
  let duration: TimeInterval

  public init(
    type: SMToastView.ToastType,
    duration: TimeInterval = 3.0
  ) {
    self.type = type
    self.duration = duration
  }
}

public struct SMToastView: View {

  public enum ToastType: Equatable {
    case error(String)
    case warning(String)
    case success(String)

    var title: String {
      switch self {
      case .error(let title):
        return title
      case .warning(let title):
        return title
      case .success(let title):
        return title
      }
    }

    var color: Color {
      switch self {
      case .error:
        return .ds(.red)
      case .warning:
        return .ds(.orange)
      case .success:
        return .ds(.green)
      }
    }

    var iconImage: Image {
      switch self {
      case .error:
        return .init(icon: .delete)
      case .warning:
        return .init(icon: .warning)
      case .success:
        return .init(icon: .check)
      }
    }

    var iconSize: CGFloat {
      switch self {
      case .success:
        return 12.0
      default:
        return 18.0
      }
    }
  }

  private let title: String
  private let type: ToastType

  public init(
    for type: ToastType
  ) {
    self.title = type.title
    self.type = type
  }

  public var body: some View {
    HStack {
      Circle()
        .fill(type.color)
        .frame(width: 24, height: 24)
        .overlay {
          type.iconImage
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: type.iconSize, height: type.iconSize)
        }

      Text(title)
        .font(.ds(.title4))
        .foregroundColor(.ds(.white))
    }
    .padding()
    .frame(height: 48)
    .background(Color.ds(.gray4))
    .cornerRadius(24)
    .shadow(radius: 4)
  }
}

struct SMToastView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      SMToastView(for: .success("살말 업로드 완료!"))
        .previewDisplayName("성공 토스트")
        .previewLayout(.sizeThatFits)

      SMToastView(for: .warning("화면 캡처를 감지했어요."))
        .previewDisplayName("경고 토스트")
        .previewLayout(.sizeThatFits)

      SMToastView(for: .error("더 이상 해당 사용자가 피드에서 보이지 않아요."))
        .previewDisplayName("에러 토스트")
        .previewLayout(.sizeThatFits)
    }
  }
}
