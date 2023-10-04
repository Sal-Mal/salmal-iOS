import Foundation

public struct MemberListDTO: Responsable {
  public let hasNext: Bool
  public let members: [MemberDTO]
}


// MARK: - Extension

extension MemberListDTO {

  public static var mock: MemberListDTO {
    return MemberListDTO(
      hasNext: true,
      members: [.mock, .mock, .mock, .mock]
    )
  }

  public static var mockBlocked: MemberListDTO {
    return MemberListDTO(
      hasNext: true,
      members: [.mockBlocked, .mockBlocked, .mockBlocked, .mockBlocked, .mockBlocked, .mockBlocked]
    )
  }
}
