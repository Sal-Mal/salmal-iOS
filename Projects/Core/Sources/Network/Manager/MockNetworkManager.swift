import Foundation

/// 테스트시 사용하는 NetworkManager
public struct MockNetworkManager: NetworkManager {
  public func request<T: Responsable>(_ target: TargetType, type: T.Type) async throws -> T {
    return type.mock
  }
  
  public func request(_ target: TargetType) async throws -> Data {
    return Data()
  }
}
