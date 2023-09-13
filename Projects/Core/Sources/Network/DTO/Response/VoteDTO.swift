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
  public let commentCnt: Int
  public let likeCnt: Int
  public let disLikeCnt: Int
  public let totalEvaludationCnt: Int
  public let bookMarkCnt: Int
  public let createdDate: Date
  public let isBookmarked: Bool
}

extension VoteDTO {
  public static var mock: VoteDTO {
    VoteDTO(
      id: (0...1000).randomElement()!,
      imageUrl: "https://picsum.photos/300/600",
      nickName: "dudu",
      memberImageUrl: "https://picsum.photos/100",
      commentCnt: (0...100).randomElement()!,
      likeCnt: (0...100).randomElement()!,
      disLikeCnt: (0...100).randomElement()!,
      totalEvaludationCnt: (100...1000).randomElement()!,
      bookMarkCnt: (100...1000).randomElement()!,
      createdDate: Date.now,
      isBookmarked: Bool.random()
    )
  }
  
  public var toDomian: Vote {
    Vote(
      id: id,
      imageURL: imageUrl,
      nickName: nickName,
      memberImageURL: memberImageUrl,
      commentCnt: commentCnt,
      likeCount: likeCnt,
      disLikeCount: disLikeCnt,
      totalVoteCount: totalEvaludationCnt,
      bookmarkCount: bookMarkCnt,
      isBookmarked: isBookmarked
    )
  }
}