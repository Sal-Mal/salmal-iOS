import Foundation
import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias Parameters = Alamofire.Parameters
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias EmptyResponse = Alamofire.EmptyResponse
public typealias MultipartFormData = Alamofire.MultipartFormData

/// 실제로 쓰는 NetworkManager
public struct DefaultNetworkService: NetworkService {
  
  private let session: Session
  private let retryLimit: Int
  
  public init(retryLimit: Int = 3) {
    self.session = .default
    self.retryLimit = retryLimit
  }
  
  public func request<T: Responsable>(_ target: TargetType, type: T.Type) async throws -> T {
    let result: DataTask<T>

    switch target.task {
    case .requestPlain:
      result = session.request(target)
        .serializingDecodable(T.self, emptyResponseCodes: Set(200..<300))

    case .uploadMultipartFormData(let multipartFormData):
      result = session.upload(multipartFormData: multipartFormData, with: target)
        .serializingDecodable(T.self, emptyResponseCodes: Set(200..<300))
    }
    
    let httpResponse = await result.response.response
    
    debugPrint("StatusCode: \(httpResponse?.statusCode)")
    
    guard httpResponse?.statusCode != nil,
          (200...300) ~= httpResponse!.statusCode
    else {
      print("Invalid StatusCode")
      throw SMError.network(.invalidURLHTTPResponse)
    }
    
    do {
      let value = try await result.value
      debugPrint("Success!")
      
      return value
    } catch {
      debugPrint("ERROR!", error.localizedDescription)
      
      throw error
    }
  }
  
  public func request(_ target: TargetType) async throws -> Data {
    let result: DataTask<Data>

    switch target.task {
    case .requestPlain:
      result = session.request(target)
        .serializingData()

    case .uploadMultipartFormData(let multipartFormData):
      result = session.upload(multipartFormData: multipartFormData, with: target)
        .serializingData()
    }
    
    let httpResponse = await result.response.response
    debugPrint("StatusCode: \(httpResponse?.statusCode)")
    
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
