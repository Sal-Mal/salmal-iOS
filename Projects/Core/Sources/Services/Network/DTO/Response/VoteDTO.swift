import Foundation

/// 투표 목록 조회에서 쓰는 DTO
public struct VoteListDTO: Responsable {
  public let hasNext: Bool
  public let votes: [VoteDTO]
}

extension VoteListDTO {
  public static var mock: VoteListDTO {
    VoteListDTO(hasNext: true, votes: [.mock, .mock, .mock, .mock, .mock])
  }
}

/// 투표 조회에서 쓰는 DTO
public struct VoteDTO: Responsable {
  public let id: Int
  public let imageUrl: String
  public let nickName: String
  public let memberImageUrl: String
  public let memberId: Int
  public let commentCnt: Int
  public let likeCnt: Int
  public let disLikeCnt: Int
  public let totalEvaludationCnt: Int
//  public let bookMarkCnt: Int
  public let createdDate: Date
  public let isBookmarked: Bool
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
      commentCnt: (0...100).randomElement()!,
      likeCnt: sal,
      disLikeCnt: mal,
      totalEvaludationCnt: total,
//      bookMarkCnt: (100...1000).randomElement()!,
      createdDate: Date.now,
      isBookmarked: Bool.random(),
      status: [VoteStatus.like, .disLike, .none].randomElement()!
    )
  }
  
  public var toDomian: Vote {
    Vote(
      id: id,
      imageURL: imageUrl,
      nickName: nickName,
      memberImageURL: memberImageUrl,
      memberID: memberId,
      commentCnt: commentCnt,
      likeCount: likeCnt,
      disLikeCount: disLikeCnt,
      totalVoteCount: totalEvaludationCnt,
//      bookmarkCount: bookMarkCnt,
      isBookmarked: isBookmarked,
      voteStatus: .init(rawValue: status.rawValue)!
    )
  }
}
