import Foundation
import AuthenticationServices

import ComposableArchitecture

public final class AppleManager: NSObject {
  var keyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }.first
  }
  
  var loginContinuation: CheckedContinuation<String, Error>?
  
  public func requestLogin() async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
      self.loginContinuation = continuation
    
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      
      let authController = ASAuthorizationController(authorizationRequests: [request])
      authController.delegate = self
      authController.presentationContextProvider = self
      authController.performRequests()
    }
  }
}

extension AppleManager: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return keyWindow!
  }
}

extension AppleManager: ASAuthorizationControllerDelegate {
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let appIDCredntial = authorization.credential as? ASAuthorizationAppleIDCredential else {
      return
    }
    
    let id = appIDCredntial.user
    loginContinuation?.resume(returning: id)
  }
  
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    debugPrint("apple login 실패 \(error.localizedDescription)")
    loginContinuation?.resume(throwing: error)
  }
}


/// TCA DependencyKey를 정의
public enum AppleManagerKey: DependencyKey {
  public static let liveValue = AppleManager()
  public static let previewValue = AppleManager()
  public static let testValue = AppleManager()
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var appleManager: AppleManager {
    get { self[AppleManagerKey.self] }
    set { self[AppleManagerKey.self] = newValue }
  }
}
