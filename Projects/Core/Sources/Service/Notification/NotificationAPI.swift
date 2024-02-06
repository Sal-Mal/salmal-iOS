import Foundation

public enum NotificationAPI {
  case fcm(FCMTokenRequestDTO)
  case list // 알람조회
  case delete(AlarmRequestDTO) // 알람삭제
  case read(AlarmRequestDTO) // 알람확인
}

extension NotificationAPI: TargetType {
  public var path: String {
    switch self {
    case .fcm:
      return "fcm/add-token"
    case .list:
      return "notification"
    case .delete:
      return "notification"
    case .read:
      return "notification/read"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .fcm:
      return .post
    case .list:
      return .get
    case .delete:
      return .delete
    case .read:
      return .post
    }
  }
  
  public var parameters: Encodable? {
    switch self {
    case let .fcm(params):
      return params
    case .list:
      return nil
    case let .delete(params):
      return params
    case let .read(params):
      return params
    }
  }
  
  public var headers: [String : String]? {
    return [
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"
    ]
  }
  
  public var task: HTTPTask {
    return .requestPlain
  }
}
