import Foundation

public struct BlockedMemberListResponse: Responsable {
  public let hasNext: Bool
  public let members: [MemberResponse]

  public enum CodingKeys: String, CodingKey {
    case hasNext
    case members = "blockedMembers"
  }
}


// MARK: - Extension

extension BlockedMemberListResponse {

  public static var mock: BlockedMemberListResponse {
    return BlockedMemberListResponse(
      hasNext: true,
      members: [.mockBlocked, .mockBlocked, .mockBlocked, .mockBlocked]
    )
  }
}
