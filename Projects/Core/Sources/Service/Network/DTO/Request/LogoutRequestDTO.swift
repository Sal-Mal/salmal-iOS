import Foundation

/// 로그 아웃
public struct LogoutRequestDTO: Encodable {
  let refreshToken: String
}
