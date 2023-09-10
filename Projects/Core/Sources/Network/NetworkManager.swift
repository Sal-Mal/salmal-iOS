import Foundation
import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias Parameters = Alamofire.Parameters
public typealias HTTPHeaders = Alamofire.HTTPHeaders

public final class NetworkManager {
  
  private let session: Session
  private let retryLimit: Int
  
  public init(retryLimit: Int = 3) {
    self.session = .default
    self.retryLimit = retryLimit
  }
  
  public func request<T: Decodable>(_ target: TargetType, type: T.Type) async throws -> T {
    let data = try await request(target)
    let result = try JSONDecoder().decode(type, from: data)
    
    return result
  }
  
  public func request(_ target: TargetType) async throws -> Data {
    let dataRequest = try dataRequest(target)
    let result = dataRequest
      .serializingResponse(using: .data)
    
    return try await result.value
  }
  
  private func dataRequest(_ target: TargetType) throws -> DataRequest {
    guard let url = URL(string: "\(target.baseURL)/\(target.path)") else {
      throw SMError.network(.invalidURL)
    }
    
    return session.request(
      url,
      method: target.method,
      parameters: target.parameters,
      encoding: URLEncoding.default,
      headers: target.headers,
      interceptor: RetryInterceptor(retryLimit: retryLimit)
    )
  }
}
