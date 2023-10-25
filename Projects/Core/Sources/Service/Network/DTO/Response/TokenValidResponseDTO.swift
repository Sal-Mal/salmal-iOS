import Foundation

public struct TokenValidResponseDTO: Responsable {
  let available: Bool
}

extension TokenValidResponseDTO {
  public static var mock: TokenValidResponseDTO {
    .init(available: true)
  }
}
