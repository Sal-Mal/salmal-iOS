import Foundation
import Dependencies

// MARK: - UserDefaultsKey

public enum UDKey: String {
  case socialProvider
  case socialID
  case refreshToken
  case accessToken
  case memberID
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
  public var accessToken: String? {
    didSet {
      if let accessToken { memberID = parseID(jwtToken: accessToken) }
    }
  }
  
  @UD(key: UDKey.memberID)
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
