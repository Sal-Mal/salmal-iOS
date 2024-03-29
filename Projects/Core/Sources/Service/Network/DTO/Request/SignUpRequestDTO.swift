import Foundation

/// 회원가입
public struct SignUpRequestDTO: Encodable {
  let providerId: String
  let nickName: String
  let marketingInformationConsent: Bool
  
  public init(providerId: String, nickName: String, marketingInformationConsent: Bool) {
    self.providerId = providerId
    self.nickName = nickName
    self.marketingInformationConsent = marketingInformationConsent
  }
}
