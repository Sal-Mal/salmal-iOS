import Foundation
import ComposableArchitecture

public enum CommentAPI {
  case list(id: Int)
  case write(id: Int, text: String)
  case edit(id: Int, text: String)
  case delete(id: Int)
  case like(id: Int)
  case disLike(id: Int)
  case report(id: Int)
}


// MARK: - Extension

extension CommentAPI: TargetType {
  
  public var path: String {
    switch self {
    case let .list(id):
      // TODO: Query 수정(all fetch 댓글로 변경)
      return "votes/\(id)/comments?size=100"
    case let .write(id, _):
      return "votes/\(id)/comments"
    case let .edit(id, _):
      return "comments/\(id)"
    case let .delete(id):
      return "comments/\(id)"
    case let .like(id):
      return "comments/\(id)/likes"
    case let .disLike(id):
      return "comments/\(id)/likes"
    case let .report(id):
      return "comments/\(id)/reports"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .list:
      return .get
    case .write:
      return .post
    case .edit:
      return .put
    case .delete:
      return .delete
    case .like:
      return .post
    case .disLike:
      return .delete
    case .report:
      return .delete
    }
  }
  
  public var parameters: Encodable? {
    switch self {
    case .list:
      return nil
    case let .write(_, text):
      return CommentRequestDTO(content: text)
    case let .edit(_, text):
      return CommentRequestDTO(content: text)
    case .delete:
      return nil
    case .like:
      return nil
    case .disLike:
      return nil
    case .report:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"
    ]
  }
  
  public var task: HTTPTask {
    switch self {
    default:
      return .requestPlain
    }
  }
}
