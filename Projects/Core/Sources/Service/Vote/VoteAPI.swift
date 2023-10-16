import Foundation

public enum VoteAPI {
  // TODO: 투표 등록 api
  case vote(id: Int, EvaluateVoteRequestDTO) // 투표(살, 밀)
  case unVote(id: Int)
  case bookmark(id: Int) // 북마크
  case unBookmark(id: Int) // 북마크 해제
  case report(id: Int) // 신고
  case get(id: Int) // 조회
  case delete(id: Int) // 삭제
  case homeList(size: Int, cursor: Int?, cursorLikes: Int?) // Home 목록 조회
  case bestList(size: Int, cursor: Int?, cursorLikes: Int?) // Best 목록 조회
}


// MARK: - Extension

extension VoteAPI: TargetType {
  
  public var path: String {
    switch self {
    case let .vote(id, _):
      return "votes/\(id)/evaluations"
      
    case let .unVote(id):
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
      
    case let .homeList(size, cursor, cursorLike):
      if let cursor, let cursorLike {
        return "votes?cursorId=\(cursor)&cursorLikes=\(cursorLike)size=\(size)&searchType=HOME"
      } else {
        return "votes?size=\(size)&searchType=HOME"
      }
    case let .bestList(size, cursor, cursorLike):
      if let cursor, let cursorLike {
        return "votes?cursorId=\(cursor)&cursorLikes=\(cursorLike)searchType=BEST&size=\(size)"
      } else {
        return "votes?searchType=BEST&size=\(size)"
      }
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .vote:
      return .post
      
    case .unVote:
      return .delete
      
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
      
    case .unVote:
      return nil
      
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

  public var task: HTTPTask {
    switch self {
    default:
      return .requestPlain
    }
  }
}
