import Foundation

import ComposableArchitecture

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

public final class KakaoManager {
  private let nativeKey = "5d5170916ea2715b891b88b5dc7cba0f"
  
  public func initSDK() {
    KakaoSDK.initSDK(appKey: nativeKey)
  }
  
  public func openURL(_ url: URL) {
    if AuthApi.isKakaoTalkLoginUrl(url) {
      _ = AuthController.handleOpenUrl(url: url)
    }
  }
  
  public func logIn() async throws -> Int {
    try await loginWithKakao()
    return try await requestUserID()
  }
  
  private func loginWithKakao() async throws {
    return try await withCheckedThrowingContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
          if let error {
            continuation.resume(throwing: SMError.login(.unknown(error)))
          } else {
            continuation.resume(returning: ())
          }
        }
      } else {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
          if let error {
            continuation.resume(throwing: SMError.login(.unknown(error)))
          } else {
            continuation.resume(returning: ())
          }
        }
      }
    }
  }
  
  private func requestUserID() async throws -> Int {
    return try await withCheckedThrowingContinuation { continuation in
      UserApi.shared.me { user, error in
        if let error {
          continuation.resume(throwing: SMError.login(.unknown(error)))
        }
        
        if let userID = user?.id {
          continuation.resume(returning: Int(userID))
        } else {
          continuation.resume(throwing: SMError.login(.noUserID))
        }
      }
    }
  }
}

/// TCA DependencyKey를 정의
public enum KakaoManagerKey: DependencyKey {
  public static let liveValue: KakaoManager = KakaoManager()
  public static let previewValue: KakaoManager = KakaoManager()
  public static let testValue: KakaoManager = KakaoManager()
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var kakaoManager: KakaoManager {
    get { self[KakaoManagerKey.self] }
    set { self[KakaoManagerKey.self] = newValue }
  }
}
