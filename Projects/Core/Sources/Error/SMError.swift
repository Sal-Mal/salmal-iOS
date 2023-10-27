import Foundation

public enum SMError: LocalizedError {
  public enum NetworkReason {
    case invalidURL
    case invalidResponse
    case invalidURLHTTPResponse
    case `default`
  }
  
  public enum LoginReason {
    case unknown(Error)
    case noUserID
  }
  
  case network(NetworkReason)
  case login(LoginReason)
}
