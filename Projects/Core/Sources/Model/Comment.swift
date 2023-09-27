import Foundation

public struct Comment: Equatable, Identifiable {
  public let id: Int
  public let memberId: Int
  public let memberImageUrl: String
  public let content: String
  public var liked: Bool
  public var likeCount: Int
  public let createdAt: Date
  public let updatedAt: Date
  public let replys: [ReplyComment]?
}

public struct ReplyComment: Equatable, Identifiable {
  public let id: Int
  public let memberId: Int
  public let memberImageUrl: String
  public let content: String
  public var liked: Bool
  public var likeCount: Int
  public let createdDate: Date
  public let updatedDate: Date
}
