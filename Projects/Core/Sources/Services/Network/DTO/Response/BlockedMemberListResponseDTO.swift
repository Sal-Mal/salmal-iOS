import Foundation

public struct BlockedMemberListResponseDTO: Responsable {
  public let hasNext: Bool
  public let members: [MemberResponseDTO]

  public enum CodingKeys: String, CodingKey {
    case hasNext
    case members = "blockedMembers"
  }
}


// MARK: - Extension

extension BlockedMemberListResponseDTO {

  public static var mock: BlockedMemberListResponseDTO {
    return BlockedMemberListResponseDTO(
      hasNext: true,
      members: [.mockBlocked, .mockBlocked, .mockBlocked, .mockBlocked]
    )
  }
}
