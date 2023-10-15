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

// MARK: - UserDefaultsService

public final class UserDefaultsService {
  public static let shared = UserDefaultsService()
  
  private init() { }
  
  @UserDefault(key: UserDefaultsKey.socialProvider)
  public var socialProvider: String?
  
  @UserDefault(key: UserDefaultsKey.socialID)
  public var socialID: String?
  
  @UserDefault(key: UserDefaultsKey.refreshToken)
  public var refreshToken: String?
  
  @UserDefault(key: UserDefaultsKey.accessToken)
  public var accessToken: String? {
    didSet {
      if let accessToken { memberID = parseID(jwtToken: accessToken) }
    }
  }
  
  @UserDefault(key: UserDefaultsKey.memberID)
  public var memberID: Int?
  
  public func removeAll() {
    socialProvider = nil
    socialID = nil
    refreshToken = nil
    accessToken = nil
    memberID = nil
  }
  
  private func parseID(jwtToken jwt: String) -> Int? {
    let value = jwt.components(separatedBy: ".")[1]
    
    let replacedValue = value
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")
    
    let finalValue = replacedValue
      .padding(toLength: ((replacedValue.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
    
    guard let data = Data(base64Encoded: finalValue) else { return nil }
    guard let payload = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
    guard let memberID = payload["id"] as? Int else { return nil }
    
    return memberID
  }
}

// MARK: - Dependency

public enum UDManagerKey: DependencyKey {
  public static let liveValue = UserDefaultsService.shared
  public static let previewValue = UserDefaultsService.shared
  public static let testValue = UserDefaultsService.shared
}

public extension DependencyValues {
  var userDefault: UserDefaultsService {
    get { self[UDManagerKey.self] }
    set { self[UDManagerKey.self] = newValue }
  }
}
