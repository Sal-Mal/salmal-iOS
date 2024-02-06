import Foundation

/// FCM Token을 서버에 등록
public struct FCMTokenRequestDTO: Encodable {
  let token: String
}
