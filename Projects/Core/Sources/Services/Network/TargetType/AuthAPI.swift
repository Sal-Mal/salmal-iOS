import Foundation

public enum AuthAPI: TargetType {
  case logIn(params: Encodable)
  case logOut
  case signUp(id: String, params: Encodable)
  case requestToken(params: Encodable)
  
  public var baseURL: String {
    return "http://3.38.192.126/api/auth"
  }
  
  public var path: String {
    switch self {
    case .logIn:
      return "login"
    case .logOut:
      return "logout"
    case let .signUp(id, _):
      return "signup/\(id)"
    case .requestToken:
      return "reissue"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .logIn, .logOut, .signUp:
      return .post
    case .requestToken:
      return .get
    }
  }
  
  public var parameters: Encodable? {
    switch self {
    case let .logIn(params):
      return params
    case .logOut:
      return nil
    case let .signUp(_, params):
      return params
    case let .requestToken(params):
      return params
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .logIn:
      return nil
      
    case .logOut:
      return ["Authorization": "Bearer \(UserDefaultManager.shared.accessToken ?? "")"]
      
    case .signUp:
      return nil
      
    case .requestToken:
      return nil
    }
  }
}
