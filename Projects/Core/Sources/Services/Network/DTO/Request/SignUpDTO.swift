import Foundation

public struct SignUpDTO: Encodable {
  let providerId: String
  let nickName: String
  let marketingInformationConsent: Bool
  
  public init(providerId: String, nickName: String, marketingInformationConsent: Bool) {
    self.providerId = providerId
    self.nickName = nickName
    self.marketingInformationConsent = marketingInformationConsent
  }
}
