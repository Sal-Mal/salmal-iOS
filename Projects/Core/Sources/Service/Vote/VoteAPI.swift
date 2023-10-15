import Foundation

public enum VoteAPI {
  case vote(id: Int, EvaluateVoteRequestDTO) // 투표(살, 밀)
  case bookmark(id: Int) // 북마크
  case unBookmark(id: Int) // 북마크 해제
  case report(id: Int) // 신고
  case get(id: Int) // 조회
  case delete(id: Int) // 삭제
  case homeList(size: Int, cursor: Int? = nil) // Home 목록 조회
  case bestList(size: Int, cursor: Int? = nil) // Best 목록 조회
}


// MARK: - Extension

extension VoteAPI: TargetType {
  
  public var path: String {
    switch self {
    case let .vote(id, _):
      return "votes/\(id)/evaluations"
      
    case let .bookmark(id):
      return "votes/\(id)/bookmarks"
      
    case let .unBookmark(id):
      return "votes/\(id)/bookmarks"
      
    case let .report(id):
      return "votes/\(id)/reports"
      
    case let .get(id):
      return "votes/\(id)"
      
    case let .delete(id):
      return "votes/\(id)"
      
    case let .homeList(size, cursor):
      if let cursor {
        return "votes?searchType=HOME&size=\(size)"
      } else {
        return "votes?searchType=HOME&size=\(size)"
      }
    case let .bestList(size, cursor):
      if let cursor {
        return "votes?searchType=BEST&size=\(size)"
      } else {
        return "votes?searchType=BEST&size=\(size)"
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
    return ["Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"]
  }
}
