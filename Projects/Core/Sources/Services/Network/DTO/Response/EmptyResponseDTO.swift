import Foundation

/// 빈 데이터에 사용
public struct EmptyResponseDTO: EmptyResponse, Responsable {
  
  public static func emptyValue() -> Self {
    EmptyResponseDTO.init()
  }
  
  public static var mock: EmptyResponseDTO = .init()
}
