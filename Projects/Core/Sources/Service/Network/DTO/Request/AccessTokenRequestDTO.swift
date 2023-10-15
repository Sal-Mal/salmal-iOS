import Foundation

/// 접근토큰 제발급
public struct AccessTokenRequestDTO: Encodable {
  let refreshToken: String
}
