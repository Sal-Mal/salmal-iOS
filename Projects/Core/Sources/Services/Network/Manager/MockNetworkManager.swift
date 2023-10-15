import Foundation

/// 테스트시 사용하는 NetworkManager
public struct MockNetworkManager: NetworkManager {
  
  public init() { }
  
  public func request<T: Responsable>(_ target: TargetType, type: T.Type) async throws -> T {
    try await Task.sleep(for: .seconds(2))
    return type.mock
  }
  
  public func request(_ target: TargetType) async throws -> Data {
    try await Task.sleep(for: .seconds(2))
    return Data()
  }
}
