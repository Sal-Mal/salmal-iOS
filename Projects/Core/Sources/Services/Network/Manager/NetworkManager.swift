import Foundation
import ComposableArchitecture

/// Live & Mock Manager를 추상화한 Manager
public protocol NetworkManager {
  @discardableResult
  func request<T: Responsable>(_ target: TargetType, type: T.Type) async throws -> T
  
  @discardableResult
  func request(_ target: TargetType) async throws -> Data
}

/// Response 결과로 내려오는 객체들엔 필히 채택해야함
public protocol Responsable: Decodable {
  static var mock: Self { get }
}

/// TCA DependencyKey를 정의
public enum NetworkManagerKey: DependencyKey {
  public static let liveValue: any NetworkManager = LiveNetworkManager()
  public static let previewValue: any NetworkManager = MockNetworkManager()
  public static let testValue: any NetworkManager = MockNetworkManager()
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var network: NetworkManager {
    get { self[NetworkManagerKey.self] }
    set { self[NetworkManagerKey.self] = newValue }
  }
}
