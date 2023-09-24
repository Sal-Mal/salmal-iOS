import Foundation
import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias Parameters = Alamofire.Parameters
public typealias HTTPHeaders = Alamofire.HTTPHeaders

/// 실제로 쓰는 NetworkManager
public struct LiveNetworkManager: NetworkManager {
  
  private let session: Session
  private let retryLimit: Int
  
  public init(retryLimit: Int = 3) {
    self.session = .default
    self.retryLimit = retryLimit
  }
  
  public func request<T: Responsable>(_ target: TargetType, type: T.Type) async throws -> T {
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
    return session.request(target)
  }
}
