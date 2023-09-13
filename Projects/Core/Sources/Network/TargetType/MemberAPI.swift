import Foundation

public enum MemberAPI: TargetType {
  // TODO: 네이밍은 쓰는 사람이 알아서 잘..!
  case 마이페이지조회
  case 마이페이지수정
  case 회원탈퇴
  case ban(id: Int)
  case unBan(id: Int)
  case 회원이차단한회원목록조회
  case 회원이작성한투표목록조회
  case 회원이평가한투표목록조회
  case 회원이북마크한투표목록조회
  
  public var baseURL: String {
    return "http://3.38.192.126/api/members"
  }
  
  public var path: String {
    // TODO: - path
    switch self {
    case .마이페이지조회:
      return ""
    case .마이페이지수정:
      return ""
    case .회원탈퇴:
      return ""
    case let .ban(id):
      return "\(id)/blocks"
    case let .unBan(id):
      return "\(id)/blocks"
    case .회원이차단한회원목록조회:
      return ""
    case .회원이작성한투표목록조회:
      return ""
    case .회원이평가한투표목록조회:
      return ""
    case .회원이북마크한투표목록조회:
      return ""
    }
  }
  
  public var method: HTTPMethod {
    // TODO: - type
    switch self {
    case .마이페이지조회:
      return .get
    case .마이페이지수정:
      return .get
    case .회원탈퇴:
      return .get
    case .ban:
      return .post
    case .unBan:
      return .delete
    case .회원이차단한회원목록조회:
      return .get
    case .회원이작성한투표목록조회:
      return .get
    case .회원이평가한투표목록조회:
      return .get
    case .회원이북마크한투표목록조회:
      return .get
    }
  }
  
  public var parameters: Parameters {
    return [:]
  }
  
  public var headers: HTTPHeaders {
    // TODO: - AccessToken
    return [.authorization(bearerToken: "토큰들어가야함")]
  }
}
