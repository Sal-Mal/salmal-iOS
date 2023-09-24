import Foundation

public struct LoginDTO: Encodable {
  let providerId: String
  
  public init(providerId: String) {
    self.providerId = providerId
  }
}
