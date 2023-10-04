import Foundation

public enum MemberAPI: TargetType {
  /// 마이페이지 조회
  case fetch(id: Int)
  /// 마이페이지 수정
  case update(id: Int)
  /// 회원탈퇴
  case delete(id: Int)
  /// 회원 차단
  case ban(id: Int)
  /// 회원 차단해제
  case unBan(id: Int)
  /// 회원이 차단한 회원 목록 조회
  case fetchBlocks(id: Int)
  /// 회원이 작성한 투표 목록 조회
  case fetchVotes(id: Int)
  /// 회원이 투표한 목록 조회
  case fetchEvaluations(id: Int)
  /// 회원이 북마크한 목록 조회
  case fetchBookmarks(id: Int)
  
  public var baseURL: String {
    return "http://3.38.192.126/api/members"
  }
  
  public var path: String {
    // TODO: - path
    switch self {
    case let .fetch(id):
      return "\(id)"
    case let .update(id):
      return "\(id)"
    case let .delete(id):
      return "\(id)"
    case let .ban(id):
      return "\(id)/blocks"
    case let .unBan(id):
      return "\(id)/blocks"
    case let .fetchBlocks(id):
      return "\(id)/blocks"
    case let .fetchVotes(id):
      return "\(id)/votes"
    case let .fetchEvaluations(id):
      return "\(id)/evaluations"
    case let .fetchBookmarks(id):
      return "\(id)/bookmarks"
    }
  }
  
  public var method: HTTPMethod {
    // TODO: - type
    switch self {
    case .fetch:
      return .get
    case .update:
      return .put
    case .delete:
      return .delete
    case .ban:
      return .post
    case .unBan:
      return .delete
    case .fetchBlocks:
      return .get
    case .fetchVotes:
      return .get
    case .fetchEvaluations:
      return .get
    case .fetchBookmarks:
      return .get
    }
  }
  
  public var parameters: Encodable? {
    return nil
  }
  
  public var headers: [String: String]? {
    return ["Authorization": "Bearer \(UserDefaultManager.shared.accessToken ?? "")"]
  }
}
