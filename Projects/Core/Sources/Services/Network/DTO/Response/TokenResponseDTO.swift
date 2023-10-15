import Foundation

/// 로그인, 회원가입의 결과
public struct TokenResponseDTO: Responsable {
  public let accessToken: String
  public let refreshToken: String
  
  public static var mock: TokenResponseDTO {
    return .init(
      accessToken: UUID().uuidString,
      refreshToken: UUID().uuidString
    )
  }
}
