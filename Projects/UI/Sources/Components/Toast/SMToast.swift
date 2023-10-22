import UIKit

public enum SMToast: Equatable {
  case error(String)
  case warning(String)
  case success(String)
  
  var title: String {
    switch self {
    case let .error(title):
      return title
    case let .warning(title):
      return title
    case let .success(title):
      return title
    }
  }

  var color: UIColor {
    switch self {
    case .error:
      return .ds(.red)
    case .warning:
      return .ds(.orange)
    case .success:
      return .ds(.green1)
    }
  }

  var iconImage: UIImage? {
    switch self {
    case .error:
      return .init(icon: .ic_xmark)
    case .warning:
      return .init(icon: .ic_exclamation)
    case .success:
      return .init(icon: .ic_check)
    }
  }
}
