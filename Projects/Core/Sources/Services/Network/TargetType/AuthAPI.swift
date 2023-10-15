import Foundation

public enum AuthAPI: TargetType {
  case logIn(params: LoginRequestDTO)
  case logOut
  case signUp(id: String, params: SignUpRequestDTO)
  case reIssueToken(params: AccessTokenRequestDTO)
  case checkToken
  
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
    case .reIssueToken:
      return "reissue"
    case .checkToken:
      return "tokens"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .logIn, .logOut, .signUp:
      return .post
    case .reIssueToken:
      return .post
    case .checkToken:
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
    case let .reIssueToken(params):
      return params
    case .checkToken:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .logIn:
      return nil
      
    case .logOut:
      return ["Authorization": "Bearer \(UDManager.shared.accessToken ?? "")"]
      
    case .signUp:
      return nil
      
    case .reIssueToken:
      return nil
      
    case .checkToken:
      return ["Authorization": "Bearer \(UDManager.shared.accessToken ?? "")"]
    }
  }
}
