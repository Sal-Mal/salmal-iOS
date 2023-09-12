import Foundation

struct VoteListDTO: Responsable {
  let hasNext: Bool
  let votes: [VoteDTO]
}

extension VoteListDTO {
  static var mock: VoteListDTO {
    VoteListDTO(hasNext: true, votes: [.mock, .mock, .mock, .mock, .mock])
  }
}

struct VoteDTO: Responsable {
  let imageUrl: String
  let nickName: String
  let memberImageUrl: String
  let reviewCnt: Int
  let likeCnt: Int
  let disLikeCnt: Int
  let totalEvaludationCnt: Int
}

extension VoteDTO {
  static var mock: VoteDTO {
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
