import Foundation

public enum VoteAPI: TargetType {
  case vote // 투표(살, 밀)
  case bookmark // 북마크
  case report // 신고
  case get // 조회
  case delete // 삭제
  case getList(size: Int) // 목록조회
  
  public var baseURL: String {
    return "http://3.38.192.126"
  }
  
  // TODO: - jwt payload에서 vote-id 추가하기
  
  public var path: String {
    switch self {
    case .vote:
      return "api/votes/{vote-id}/evaluations"
    case .bookmark:
      return "api/votes/{vote-id}/bookmarks"
    case .report:
      return "api/votes/{vote-id}/reports"
    case .get:
      return "api/votes/{vote-id}"
    case .delete:
      return "api/votes/{vote-id}"
    case let .getList(size):
      return "api/votes/?size=\(size)"
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
    case .getList:
      return .get
    }
  }
  
  public var parameters: Parameters {
    // TODO: - Parameters
    return [:]
  }
  
  public var headers: HTTPHeaders {
    // TODO: - AccessToken
    return [.authorization(bearerToken: "토큰들어가야함")]
  }
}
