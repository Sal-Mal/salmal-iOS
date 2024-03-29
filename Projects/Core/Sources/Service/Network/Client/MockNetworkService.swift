import Foundation

/// 테스트시 사용하는 NetworkManager
public struct MockNetworkService: NetworkService {
  
  public init() { }
  
  public func request<T: Responsable>(_ target: TargetType, type: T.Type) async throws -> T {
    try await Task.sleep(for: .seconds(2))
    return type.mock
  }
  
  public func request(_ target: TargetType) async throws {
    try await Task.sleep(for: .seconds(2))
  }
}
