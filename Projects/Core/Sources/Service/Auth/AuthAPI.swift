import Foundation

public enum AuthAPI {
  case logIn(params: LoginRequestDTO)
  case logOut
  case signUp(id: String, params: SignUpRequestDTO)
  case reIssueToken(params: AccessTokenRequestDTO)
  case checkToken
}


// MARK: - Extension

extension AuthAPI: TargetType {

  public var path: String {
    switch self {
    case .logIn:
      return "auth/login"
    case .logOut:
      return "auth/logout"
    case let .signUp(id, _):
      return "auth/signup/\(id)"
    case .reIssueToken:
      return "auth/reissue"
    case .checkToken:
      return "auth/tokens"
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
      return ["Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"]
      
    case .signUp:
      return nil
      
    case .reIssueToken:
      return nil
      
    case .checkToken:
      return ["Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"]
    }
  }

  public var task: HTTPTask {
    switch self {
    default:
      return .requestPlain
    }
  }
}
