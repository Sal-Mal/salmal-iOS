import Foundation
import ComposableArchitecture

public protocol AuthRepository {
  func logIn(providerID: String) async throws
  func logOut() async throws
  func signUp(
    socialProvider: String,
    providerID: String,
    nickName: String,
    marketingInformationConsent: Bool
  ) async throws
  
  func reissueToken() async throws
  func checkToken() async throws
}

public final class AuthRepositoryImpl: AuthRepository {
  
  private let networkManager: NetworkService

  @Dependency(\.userDefault) var userDefault

  public init(networkManager: NetworkService) {
    self.networkManager = networkManager
  }
  
  public func logIn(providerID: String) async throws {
    let target = AuthAPI.logIn(params: LoginRequestDTO(providerId: providerID))
    let dto = try await networkManager.request(target, type: TokenResponseDTO.self)
    
    userDefault.accessToken = dto.accessToken
    userDefault.refreshToken = dto.refreshToken
  }
  
  public func logOut() async throws {
    guard let refreshToken = userDefault.refreshToken else {
      return debugPrint("Refresh Token이 없습니다")
    }
    
    let target = AuthAPI.logOut(params: .init(refreshToken: refreshToken))
    try await networkManager.request(target, type: EmptyResponseDTO.self)
    
    userDefault.accessToken = nil
    userDefault.refreshToken = nil
  }
  
  public func signUp(
    socialProvider: String,
    providerID: String,
    nickName: String,
    marketingInformationConsent: Bool
  ) async throws {
    let target = AuthAPI.signUp(id: socialProvider, params: .init(
      providerId: providerID,
      nickName: nickName,
      marketingInformationConsent: marketingInformationConsent
    ))
    let dto = try await networkManager.request(target, type: TokenResponseDTO.self)
    
    userDefault.accessToken = dto.accessToken
    userDefault.refreshToken = dto.refreshToken
  }
  
  public func reissueToken() async throws {
    guard let refreshToken = userDefault.refreshToken else {
      return debugPrint("Refresh Token이 없습니다")
    }
    
    let target = AuthAPI.reissueToken(params: .init(refreshToken: refreshToken))
    let dto = try await networkManager.request(target, type: AccessTokenResponseDTO.self)
    
    userDefault.accessToken = dto.accessToken
  }
  
  public func checkToken() async throws {
    let target = AuthAPI.checkToken
    try await networkManager.request(target, type: TokenValidResponseDTO.self)
  }
}
