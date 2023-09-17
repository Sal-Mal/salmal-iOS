import Foundation

struct TokenDTO: Responsable {
  let accessToken: String
  let refreshToken: String
  
  static var mock: TokenDTO {
    return .init(
      accessToken: UUID().uuidString,
      refreshToken: UUID().uuidString
    )
  }
}
