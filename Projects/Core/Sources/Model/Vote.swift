import Foundation

public struct Vote: Equatable {
  public let imageURL: String
  public let nickName: String
  public let memberImageURL: String
  public let commentCnt: Int
  public let likeCount: Int
  public let disLikeCount: Int
  public let totalVoteCount: Int
}
