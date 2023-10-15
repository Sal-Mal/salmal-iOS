import Foundation

/// 접근토큰 제발급
public struct AccessTokenRequest: Encodable {
  let refreshToken: String
}
