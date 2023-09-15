import Foundation

public struct Vote: Equatable, Identifiable {
  public let id: Int
  public let imageURL: String
  public let nickName: String
  public let memberImageURL: String
  public let memberID: Int
  public let commentCnt: Int
  public let likeCount: Int
  public let disLikeCount: Int
  public let totalVoteCount: Int
//  public let bookmarkCount: Int
//  public let createdDate: Date
  public let isBookmarked: Bool
}
