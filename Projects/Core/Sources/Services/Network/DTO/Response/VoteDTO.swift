import Foundation

/// 투표 목록 조회에서 쓰는 DTO
public struct VoteListDTO: Responsable {
  public let hashNext: Bool
  public let votes: [VoteDTO]
}

extension VoteListDTO {
  public static var mock: VoteListDTO {
    VoteListDTO(hashNext: true, votes: [.mock, .mock, .mock, .mock, .mock])
  }
}

/// 투표 조회에서 쓰는 DTO
public struct VoteDTO: Responsable {
  public let id: Int
  public let imageUrl: String
  public let nickName: String
  public let memberImageUrl: String
  public let memberId: Int
  public let commentCount: Int
  public let likeCount: Int
  public let disLikeCount: Int
  public let totalEvaluationCount: Int
//  public let bookMarkCnt: Int
  public let createdAt: Date
  public let bookmarked: Bool
  public let status: VoteStatus
  
  public enum VoteStatus: String, Decodable {
    case like
    case disLike
    case none
  }
}

extension VoteDTO {
  public static var mock: VoteDTO {
    let total = (100...1000).randomElement()!
    let sal = (0...total).randomElement()!
    let mal = total - sal
    
    return VoteDTO(
      id: (0...1000).randomElement()!,
      imageUrl: "https://picsum.photos/300/600",
      nickName: "dudu",
      memberImageUrl: "https://picsum.photos/100",
      memberId: 0,
      commentCount: (0...100).randomElement()!,
      likeCount: sal,
      disLikeCount: mal,
      totalEvaluationCount: total,
//      bookMarkCnt: (100...1000).randomElement()!,
      createdAt: Date.now,
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
      totalVoteCount: totalEvaluationCount,
//      bookmarkCount: bookMarkCnt,
      isBookmarked: bookmarked,
      voteStatus: .init(rawValue: status.rawValue)!
    )
  }
}
