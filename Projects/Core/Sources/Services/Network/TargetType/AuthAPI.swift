import Foundation

public enum AuthAPI: TargetType {
  case logIn(id: String)
  case logOut
  case signUp(id: String, body: Encodable)
  case requestToken(body: Encodable)
  
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
  
  public var parameters: Parameters {
    switch self {
    case let .logIn(id):
      // TODO: return provider id
      return [:]
    case .logOut:
      return [:]
    case let .signUp(id, body):
      // TODO: return body
      return [:]
    case .requestToken:
      // TODO: return refreshToken
      return [:]
    }
  }
  
  public var headers: HTTPHeaders {
    switch self {
    case let .logIn(id):
      return []
    case .logOut:
      // TODO: Header
      return []
    case let .signUp(id, body):
      return []
    case .requestToken:
      return []
    }
    return []
  }
}
