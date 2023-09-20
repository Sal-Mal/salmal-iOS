import Foundation

// MARK: - UserDefaultsKey

enum UserDefaultsKey: String {
  case socialProvider
  case socialID
  case refreshToken
  case accessToken
}

// MARK: - UserDefaultsManager

public enum UserDefaultManager {
  
  @UserDefault(key: UserDefaultsKey.socialProvider)
  public static var socialProvider: String?
  
  @UserDefault(key: UserDefaultsKey.socialID)
  public static var socialID: String?
  
  @UserDefault(key: UserDefaultsKey.refreshToken)
  public static var refreshToken: String?
  
  @UserDefault(key: UserDefaultsKey.accessToken)
  public static var accessToken: String?
}
