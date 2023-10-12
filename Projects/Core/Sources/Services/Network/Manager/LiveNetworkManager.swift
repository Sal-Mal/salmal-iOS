import Foundation
import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias Parameters = Alamofire.Parameters
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias EmptyResponse = Alamofire.EmptyResponse

/// 실제로 쓰는 NetworkManager
public struct LiveNetworkManager: NetworkManager {
  
  private let session: Session
  private let retryLimit: Int
  
  public init(retryLimit: Int = 3) {
    self.session = .default
    self.retryLimit = retryLimit
  }
  
  public func request<T: Responsable>(_ target: TargetType, type: T.Type) async throws -> T {
    let result = session.request(target)
      .serializingDecodable(T.self)
    
    return try await result.value
  }
  
  public func request(_ target: TargetType) async throws -> Data {
    let result = session.request(target)
      .serializingData()
    
    return try await result.value
  }
}
