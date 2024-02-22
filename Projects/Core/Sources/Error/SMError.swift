import Foundation

public enum SMError: LocalizedError {
  public enum NetworkReason {
    case invalidURL
    case invalidResponse
    case invalidURLHTTPResponse(Int? = nil)
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

  public enum ServiceReason {
    case fetchAlbumImageFailed
  }
  
  case network(NetworkReason)
  case login(LoginReason)
  case authorization(reason: AuthorizationReason)
  case service(reason: ServiceReason)
}


extension SMError {

  public var errorDescription: String? {
    switch self {
    case .network(let reason):
      return reason.errorDescription
    case .login(let reason):
      return reason.errorDescription
    case .authorization(let reason):
      return reason.errorDescription
    case .service(let reason):
      return reason.errorDescription
    }
  }
}

extension SMError.NetworkReason {

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "올바르지 않은 URL입니다."
    case .invalidResponse:
      return "올바르지 않은 응답 객체입니다."
    case .invalidURLHTTPResponse:
      return "올바르지 않은 HTTP 응답입니다."
    case .emptyRefreshToken:
      return "갱신 토큰을 찾을 수 없습니다."
    case .default:
      return "서버와의 통신에 실패했습니다. 다시 시도해주세요."
    }
  }
}

extension SMError.LoginReason {

  var errorDescription: String? {
    switch self {
    case .unknown(let error):
      return error.localizedDescription
    case .noUserID:
      return "사용자 ID를 찾을 수 없습니다."
    }
  }
}

extension SMError.AuthorizationReason {

  var errorDescription: String? {
    switch self {
    case .photoLibrary:
      return "이미지를 가져올 수 없어요. 권한을 허용해주세요"
    }
  }
}

extension SMError.ServiceReason {

  var errorDescription: String? {
    switch self {
    case .fetchAlbumImageFailed:
      return "이미지를 가져오는데 실패했어요."
    }
  }
}
