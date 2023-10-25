import Foundation

/// 접근 토큰 재발급
public struct AccessTokenRequestDTO: Encodable {
  let refreshToken: String
}
