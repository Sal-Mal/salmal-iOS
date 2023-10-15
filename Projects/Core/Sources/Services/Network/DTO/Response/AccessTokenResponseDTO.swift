import Foundation

public struct AccessTokenResponseDTO: Responsable {
  let authType: String
  let accessToken: String
  
  public static var mock: AccessTokenResponseDTO {
    AccessTokenResponseDTO(authType: "KAKAO", accessToken: UUID().uuidString)
  }
}
