import Foundation

public struct Comment: Equatable, Identifiable {
  public let id: Int
  public let memberId: Int
  public let nickName: String
  public let memberImageUrl: String
  public let content: String
  public var liked: Bool
  public var likeCount: Int
  public let createdAt: Date
  public let updatedAt: Date
  public let replyCount: Int?
}
