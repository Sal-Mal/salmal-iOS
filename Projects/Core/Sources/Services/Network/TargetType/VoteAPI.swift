import Foundation

public enum VoteAPI: TargetType {
  case vote(id: Int, EvaluateVoteRequestDTO) // 투표(살, 밀)
  case bookmark(id: Int) // 북마크
  case unBookmark(id: Int) // 북마크 해제
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
    case let .vote(id, _):
      return "\(id)/evaluations"
      
    case let .bookmark(id):
      return "\(id)/bookmarks"
      
    case let .unBookmark(id):
      return "\(id)/bookmarks"
      
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
      
    case .unBookmark:
      return .delete
      
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
    switch self {
    case let .vote(_, params):
      return params
    case .bookmark:
      return nil
    case .unBookmark:
      return nil
    case .report:
      return nil
    case .get:
      return nil
    case .delete:
      return nil
    case .homeList:
      return nil
    case .bestList:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    return ["Authorization": "Bearer \(UDManager.shared.accessToken ?? "")"]
  }
}
