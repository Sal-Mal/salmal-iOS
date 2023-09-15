import Foundation

public enum SMError: LocalizedError {
  public enum NetworkReason {
    case invalidURL
    case invalidResponse
    case invalidURLHTTPResponse
  }
  
  case network(NetworkReason)
}
