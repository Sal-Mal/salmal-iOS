import Foundation
import Dependencies

// MARK: - UserDefaultsKey

public enum UDKey: String {
  case socialProvider
  case socialID
  case refreshToken
  case accessToken
}

// MARK: - UserDefaultsManager

public final class UDManager {
  public static let shared = UDManager()
  
  private init() { }
  
  @UD(key: UDKey.socialProvider)
  public var socialProvider: String?
  
  @UD(key: UDKey.socialID)
  public var socialID: String?
  
  @UD(key: UDKey.refreshToken)
  public var refreshToken: String?
  
  @UD(key: UDKey.accessToken)
  public var accessToken: String?
  
  func removeAll() {
    socialProvider = nil
    socialID = nil
    refreshToken = nil
    accessToken = nil
  }
}

// MARK: - Dependency

public enum UDManagerKey: DependencyKey {
  public static let liveValue = UDManager.shared
  public static let previewValue = UDManager.shared
  public static let testValue = UDManager.shared
}

public extension DependencyValues {
  var userDefault: UDManager {
    get { self[UDManagerKey.self] }
    set { self[UDManagerKey.self] = newValue }
  }
}
