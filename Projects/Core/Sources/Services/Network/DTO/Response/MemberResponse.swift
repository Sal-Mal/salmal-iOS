import Foundation

public struct MemberResponse: Responsable {
  public var id: Int?
  public var nickName: String?
  public var introduction: String?
  public var imageUrl: String?
  public var likeCount: Int?
  public var disLikeCount: Int?
  public var blocked: Bool?
}


// MARK: - Extension

extension MemberResponse {

  public static var mock: MemberResponse {
    return MemberResponse(
      id: (0...1000).randomElement(),
      nickName: "관리자",
      introduction: "관리자 입니다.",
      imageUrl: "https://picsum.photos/300/600",
      likeCount: (0...100).randomElement(),
      disLikeCount: (0...100).randomElement(),
      blocked: false
    )
  }

  public static var mockBlocked: MemberResponse {
    return MemberResponse(
      id: (0...1000).randomElement(),
      nickName: "유저 \((0...1000).randomElement()!)",
      introduction: "차단된 유저 입니다.",
      imageUrl: "https://picsum.photos/300/600",
      likeCount: (0...100).randomElement(),
      disLikeCount: (0...100).randomElement(),
      blocked: true
    )
  }

  public var toDomain: Member {
    return Member(
      id: id ?? 0,
      nickName: nickName ?? "",
      introduction: introduction ?? "",
      imageURL: imageUrl ?? "",
      likeCount: likeCount ?? 0,
      disLikeCount: disLikeCount ?? 0,
      blocked: blocked ?? false
    )
  }
}
