import Foundation
import Alamofire
import ComposableArchitecture

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias Parameters = Alamofire.Parameters
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias EmptyResponse = Alamofire.EmptyResponse
public typealias MultipartFormData = Alamofire.MultipartFormData

/// 실제로 쓰는 NetworkManager
public struct DefaultNetworkService: NetworkService {
  
  private let session: Session
  private let retryLimit: Int
  private let interceptor = Interceptor()
  
  @Dependency(\.userDefault) var userDefault
  
  public init(retryLimit: Int = 3) {
    self.session = .default
    self.retryLimit = retryLimit
  }
  
  public func request<T: Responsable>(_ target: TargetType, type: T.Type) async throws -> T {
    let result = try await self.requestData(target)
    
    // 성공
    switch result {
    case let .success(data):
      return try JSONDecoder().decode(T.self, from: data)
      
    // 실패!
    case let .failure(error):
      debugPrint("실패: \(error.localizedDescription)")
      throw error
    }
  }
  
  public func request(_ target: TargetType) async throws {
    let result = try await self.requestData(target)
    
    // 실패!
    if case let .failure(error) = result {
      debugPrint("실패: \(error.localizedDescription)")
      throw error
    }
    
    // 성공!
    debugPrint("성공!")
  }
  
  private func requestData(_ target: TargetType) async throws -> Result<Data, AFError> {
    let result: DataTask<Data>
    
    switch target.task {
    case .requestPlain:
      result = session.request(target)
        .serializingData(emptyResponseCodes: Set(200..<300))
      
    case .uploadMultipartFormData(let multipartFormData):
      result = session.upload(
        multipartFormData: multipartFormData,
        with: target
      )
        .serializingData(emptyResponseCodes: Set(200..<300))
    }
    
    let dataResponse = await result.response
    
    /// access Token 만료시(401 error) 갱신
    if dataResponse.response?.statusCode == 401 {
      try await self.reissueToken()
      return try await self.requestData(target)
    }
    
    debugPrint("StatusCode: \(dataResponse.response?.statusCode)")
    debugPrint(dataResponse.data?.prettifyJSONString)
    
    guard let statusCode = dataResponse.response?.statusCode,
          (200..<300) ~= statusCode
    else {
      debugPrint("실패: InvalidStatusCode")
      try self.printErrorMessage(dataResponse.data)
      throw SMError.network(.invalidURLHTTPResponse)
    }
    
    return dataResponse.result
  }
  
  /// 에러 메시지를 디코딩후 출력
  private func printErrorMessage(_ data: Data?) throws {
    guard let data else { return }
    
    let errorModel = try JSONDecoder().decode(DefaultErrorResponseDTO.self, from: data)
    debugPrint("ErrorMessage: \(errorModel.message)")
  }
  
  /// accessToken 갱신
  private func reissueToken() async throws {
    guard let refreshToken = userDefault.refreshToken else {
      debugPrint("Refresh Token이 없습니다")
      throw SMError.network(.emptyRefreshToken)
    }
    
    let target = AuthAPI.reissueToken(params: .init(refreshToken: refreshToken))
    let dto = try await self.request(target, type: AccessTokenResponseDTO.self)
    userDefault.accessToken = dto.accessToken
  }
}
