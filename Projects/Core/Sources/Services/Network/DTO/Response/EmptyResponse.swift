import Foundation

/// 빈 데이터에 사용
public struct EmptyEntity: EmptyResponse, Responsable {
  
  public static func emptyValue() -> Self {
    EmptyEntity.init()
  }
  
  public static var mock: EmptyEntity = .init()
}
