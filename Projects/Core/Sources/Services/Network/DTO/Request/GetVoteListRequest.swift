import Foundation

public struct GetVoteListRequest: Encodable {
  public let cursorId: Int
  public let size: Int

  private enum CodingKeys: String, CodingKey {
    case cursorId = "cursor-id"
    case size
  }
}
