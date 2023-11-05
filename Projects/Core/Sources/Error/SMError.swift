import Foundation

public enum SMError: LocalizedError {
  public enum NetworkReason {
    case invalidURL
    case invalidResponse
    case invalidURLHTTPResponse
    case emptyRefreshToken
    case `default`
  }
  
  public enum LoginReason {
    case unknown(Error)
    case noUserID
  }

  public enum AuthorizationReason {
    case photoLibrary
  }
  
  case network(NetworkReason)
  case login(LoginReason)
  case authorization(reason: AuthorizationReason)
}


extension SMError {

  public var errorDescription: String? {
    switch self {
    case .network(let reason):
      return "네트워크 오류"
    case .login(let reason):
      return "로그인 오류"
    case .authorization(let reason):
      switch reason {
      case .photoLibrary:
        return "이미지를 가져올 수 없어요.\n설정에서 권한을 허용해주세요"
      }
    }
  }
}
