import Foundation

/// 로그인
public struct LoginRequest: Encodable {
  let providerId: String
  
  public init(providerId: String) {
    self.providerId = providerId
  }
}
