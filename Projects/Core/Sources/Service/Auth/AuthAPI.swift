import Foundation

public enum AuthAPI {
  case logIn(params: LoginRequestDTO)
  case logOut(params: LogoutRequestDTO)
  case signUp(id: String, params: SignUpRequestDTO)
  case reissueToken(params: AccessTokenRequestDTO)
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
    case .reissueToken:
      return "auth/reissue"
    case .checkToken:
      return "auth/tokens"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .logIn, .logOut, .signUp:
      return .post
    case .reissueToken:
      return .post
    case .checkToken:
      return .get
    }
  }
  
  public var parameters: Encodable? {
    switch self {
    case let .logIn(params):
      return params
      
    case let .logOut(params):
      return params
      
    case let .signUp(_, params):
      return params
      
    case let .reissueToken(params):
      return params
      
    case .checkToken:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .logIn:
      return ["Content-Type": "application/json; charset=UTF-8"]
      
    case .logOut:
      return [
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"
      ]
      
    case .signUp:
      return ["Content-Type": "application/json; charset=UTF-8"]
      
    case .reissueToken:
      return ["Content-Type": "application/json; charset=UTF-8"]
      
    case .checkToken:
      return [
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"
      ]
    }
  }

  public var task: HTTPTask {
    switch self {
    default:
      return .requestPlain
    }
  }
}
