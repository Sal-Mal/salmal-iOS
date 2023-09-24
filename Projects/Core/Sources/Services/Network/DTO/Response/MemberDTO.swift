import Foundation

public struct MemberDTO: Responsable {
  public var id: Int?
  public var nickName: String?
  public var introduction: String?
  public var imageUrl: String?
  public var likeCnt: Int?
  public var disLikeCnt: Int?
  public var blockedDate: Date? // 필요없을 듯
}


// MARK: - Extension

extension MemberDTO {

  public static var mock: MemberDTO {
    return MemberDTO(
      id: (0...1000).randomElement(),
      nickName: "관리자",
      introduction: "관리자 입니다.",
      imageUrl: "https://picsum.photos/300/600",
      likeCnt: (0...100).randomElement(),
      disLikeCnt: (0...100).randomElement(),
      blockedDate: nil
    )
  }

  public static var mockBlocked: MemberDTO {
    return MemberDTO(
      id: (0...1000).randomElement(),
      nickName: "유저 \((0...1000).randomElement()!)",
      introduction: "차단된 유저 입니다.",
      imageUrl: "https://picsum.photos/300/600",
      likeCnt: (0...100).randomElement(),
      disLikeCnt: (0...100).randomElement(),
      blockedDate: Date.now
    )
  }

  public var toDomain: Member {
    return Member(
      id: id ?? 0,
      nickName: nickName ?? "",
      introduction: introduction ?? "",
      imageURL: imageUrl ?? "",
      likeCount: likeCnt ?? 0,
      disLikeCount: disLikeCnt ?? 0,
      blockedDate: blockedDate
    )
  }
}
