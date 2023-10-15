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
      .serializingDecodable(T.self, emptyResponseCodes: Set(200..<300))
    
    do {
      let value = try await result.value
      debugPrint("Success!", value)
      
      return value
    } catch {
      debugPrint("ERROR!", error.localizedDescription)
      
      throw error
    }
  }
  
  public func request(_ target: TargetType) async throws -> Data {
    let result = session.request(target)
      .serializingData()
    
    do {
      let value = try await result.value
      debugPrint("Success!")
      
      return value
    } catch {
      debugPrint("ERROR!", error.localizedDescription)
      throw error
    }
  }
}
