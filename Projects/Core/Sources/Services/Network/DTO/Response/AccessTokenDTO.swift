import Foundation

public struct AccessTokenDTO: Responsable {
  let authType: String
  let accessToken: String
  
  public static var mock: AccessTokenDTO {
    AccessTokenDTO(authType: "KAKAO", accessToken: UUID().uuidString)
  }
}
