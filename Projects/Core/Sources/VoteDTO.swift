import Foundation

struct VoteListDTO: Decodable {
  let hasNext: Bool
  let votes: [VoteDTO]
}

struct VoteDTO: Decodable {
  let imageUrl: String
  let nickName: String
  let memberImageUrl: String
  let reviewCnt: Int
  let likeCnt: Int
  let disLikeCnt: Int
  let totalEvaludationCnt: Int
}

extension VoteDTO {
  static var dummy: VoteDTO {
    VoteDTO(
      imageUrl: "https://picsum.photos/300/600",
      nickName: "dudu",
      memberImageUrl: "https://picsum.photos/100",
      reviewCnt: 100,
      likeCnt: 34,
      disLikeCnt: 66,
      totalEvaludationCnt: 100
    )
  }
}
