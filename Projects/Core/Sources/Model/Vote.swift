import Foundation

public struct VoteList: Equatable {
  public let hasNext: Bool
  public let votes: [Vote]
}

public struct Vote: Equatable, Identifiable {
  public let id: Int
  public let imageURL: String
  public let nickName: String
  public let memberImageURL: String
  public let memberID: Int
  public let commentCnt: Int
  public var likeCount: Int
  public var disLikeCount: Int
  public var totalVoteCount: Int
  public var isBookmarked: Bool
  public var voteStatus: VoteStatus
  
  public enum VoteStatus: String {
    case like = "LIKE"
    case disLike = "DISLIKE"
    case none = "NONE"
  }
}
