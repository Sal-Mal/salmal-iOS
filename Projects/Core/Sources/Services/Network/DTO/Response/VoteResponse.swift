import Foundation

/// 투표 목록 조회에서 쓰는 DTO
public struct VoteListResponse: Responsable {
  public let hasNext: Bool
  public let votes: [VoteResponse]
}

extension VoteListResponse {
  public static var mock: VoteListResponse {
    VoteListResponse(hasNext: true, votes: [.mock, .mock, .mock, .mock, .mock])
  }
}

/// 투표 조회에서 쓰는 DTO
public struct VoteResponse: Responsable {
  public let id: Int
  public let imageUrl: String
  public let nickName: String
  public let memberImageUrl: String
  public let memberId: Int
  public let commentCount: Int
  public let likeCount: Int
  public let disLikeCount: Int
  public let totalEvaluationCnt: Int
  public let bookmarked: Bool
  public let status: VoteStatus
  
  public enum VoteStatus: String, Decodable {
    case like = "LIKE"
    case disLike = "DISLIKE"
    case none = "NONE"
  }
}

extension VoteResponse {
  public static var mock: VoteResponse {
    let total = (100...1000).randomElement()!
    let sal = (0...total).randomElement()!
    let mal = total - sal
    
    return VoteResponse(
      id: (0...1000).randomElement()!,
      imageUrl: "https://picsum.photos/300/600",
      nickName: "dudu",
      memberImageUrl: "https://picsum.photos/100",
      memberId: 0,
      commentCount: (0...100).randomElement()!,
      likeCount: sal,
      disLikeCount: mal,
      totalEvaluationCnt: total,
      bookmarked: Bool.random(),
      status: [VoteStatus.like, .disLike, .none].randomElement()!
    )
  }
  
  public var toDomain: Vote {
    Vote(
      id: id,
      imageURL: imageUrl,
      nickName: nickName,
      memberImageURL: memberImageUrl,
      memberID: memberId,
      commentCnt: commentCount,
      likeCount: likeCount,
      disLikeCount: disLikeCount,
      totalVoteCount: totalEvaluationCnt,
      isBookmarked: bookmarked,
      voteStatus: .init(rawValue: status.rawValue)!
    )
  }
}