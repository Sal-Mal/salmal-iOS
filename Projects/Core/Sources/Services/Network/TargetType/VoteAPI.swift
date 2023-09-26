import Foundation

public enum VoteAPI: TargetType {
  case vote(id: Int) // 투표(살, 밀)
  case bookmark(id: Int, check: Bool) // 북마크
  case report(id: Int) // 신고
  case get(id: Int) // 조회
  case delete(id: Int) // 삭제
  case homeList(size: Int, cursor: Int? = nil) // Home 목록 조회
  case bestList(size: Int, cursor: Int? = nil) // Best 목록 조회
  
  public var baseURL: String {
    return "http://3.38.192.126/api/votes"
  }
  
  public var path: String {
    switch self {
    case let .vote(id):
      return "\(id)/evaluations"
    case let .bookmark(id, check):
      // TODO: check uncheck 처리
      return "\(id)/bookmarks\(check)"
    case let .report(id):
      return "\(id)/reports"
    case let .get(id):
      return "\(id)"
    case let .delete(id):
      return "\(id)"
    case let .homeList(size, cursor):
      if let cursor {
        return "?searchType=HOME&size=\(size)"
      } else {
        return "?searchType=HOME&size=\(size)"
      }
    case let .bestList(size, cursor):
      if let cursor {
        return "?searchType=BEST&size=\(size)"
      } else {
        return "?searchType=BEST&size=\(size)"
      }
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .vote:
      return .post
    case .bookmark:
      return .post
    case .report:
      return .post
    case .get:
      return .get
    case .delete:
      return .delete
    case .homeList, .bestList:
      return .get
    }
  }
  
  public var parameters: Encodable? {
    // TODO: - Parameters
    return nil
  }
  
  public var headers: [String: String]? {
    return ["Authorization": "Bearer \(UDManager.shared.accessToken ?? "")"]
  }
}
