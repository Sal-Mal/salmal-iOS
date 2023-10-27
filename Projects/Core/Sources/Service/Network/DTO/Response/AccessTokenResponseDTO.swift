import Foundation

public struct AccessTokenResponseDTO: Responsable {
  let accessToken: String
  
  public static var mock: AccessTokenResponseDTO {
    AccessTokenResponseDTO(accessToken: UUID().uuidString)
  }
}
