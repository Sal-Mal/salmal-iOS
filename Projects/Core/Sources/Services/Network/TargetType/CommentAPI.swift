import Foundation

public enum CommentAPI: TargetType {
  case list(id: String)
  case write(id: String, text: String)
  case edit(id: String, text: String)
  case delete(id: String)
  
  public var baseURL: String {
    switch self {
    case .list, .write:
      return "http://3.38.192.126/api/votes"
    case .edit, .delete:
      return "http://3.38.192.126/api/comments"
    }
  }
  
  public var path: String {
    switch self {
    case let .list(id):
      return "\(id)/comments" // TODO: Query 추가
    case let .write(id, _):
      return "\(id)/comments"
    case let .edit(id, _):
      return "\(id)"
    case let .delete(id):
      return "\(id)"
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
    }
  }
  
  public var parameters: Encodable? {
    switch self {
    case .list:
      return nil
    case let .write(_, text):
      return CommentRequest(content: text)
    case let .edit(_, text):
      return CommentRequest(content: text)
    case .delete:
      return nil
    }
  }
  
  public var headers: [String : String]? {
    return ["Authorization": "Bearer \(UDManager.shared.accessToken ?? "")"]
  }
}
