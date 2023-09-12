import Foundation

public struct Vote: Equatable {
  let imageURL: String
  let nickName: String
  let memberImageURL: String
  let reviewCount: Int
  let likeCount: Int
  let disLikeCount: Int
  let totalVoteCount: Int
}

public extension Vote {
  static var dummy: Vote {
    Vote(
      imageURL: "https://picsum.photos/300/600",
      nickName: "dudu",
      memberImageURL: "https://picsum.photos/100",
      reviewCount: 38,
      likeCount: 34,
      disLikeCount: 66,
      totalVoteCount: 100
    )
  }
}
