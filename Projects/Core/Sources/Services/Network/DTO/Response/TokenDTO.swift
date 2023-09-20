import Foundation

public struct TokenDTO: Responsable {
  public let accessToken: String
  public let refreshToken: String
  
  public static var mock: TokenDTO {
    return .init(
      accessToken: UUID().uuidString,
      refreshToken: UUID().uuidString
    )
  }
}
