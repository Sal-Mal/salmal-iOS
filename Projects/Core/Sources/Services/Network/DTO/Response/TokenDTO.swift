import Foundation

public struct TokenDTO: Responsable {
  let accessToken: String
  let refreshToken: String
  
  public static var mock: TokenDTO {
    return .init(
      accessToken: UUID().uuidString,
      refreshToken: UUID().uuidString
    )
  }
}
