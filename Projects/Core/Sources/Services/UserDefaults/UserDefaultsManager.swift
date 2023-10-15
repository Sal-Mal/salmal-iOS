import Foundation
import Dependencies

// MARK: - UserDefaultsKey

public enum UserDefaultsKey: String {
  case socialProvider
  case socialID
  case refreshToken
  case accessToken
  case memberID
}

// MARK: - UserDefaultsManager

public final class UserDefaultManager {
  public static let shared = UserDefaultManager()
  
  private init() { }
  
  @UserDefault(key: UserDefaultsKey.socialProvider)
  public var socialProvider: String?
  
  @UserDefault(key: UserDefaultsKey.socialID)
  public var socialID: String?
  
  @UserDefault(key: UserDefaultsKey.refreshToken)
  public var refreshToken: String?
  
  @UserDefault(key: UserDefaultsKey.accessToken)
  public var accessToken: String?

  @UserDefault(key: UserDefaultsKey.memberID)
  public var memberID: Int?
  
  func removeAll() {
    socialProvider = nil
    socialID = nil
    refreshToken = nil
    accessToken = nil
    memberID = nil
  }
}

// MARK: - Dependency

public enum UserDefaultManagerKey: DependencyKey {
  public static let liveValue = UserDefaultManager.shared
  public static let previewValue = UserDefaultManager.shared
  public static let testValue = UserDefaultManager.shared
}

public extension DependencyValues {
  var userDefault: UserDefaultManager {
    get { self[UserDefaultManagerKey.self] }
    set { self[UserDefaultManagerKey.self] = newValue }
  }
}
