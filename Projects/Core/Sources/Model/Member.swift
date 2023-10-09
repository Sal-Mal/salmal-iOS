import Foundation

public struct Member: Equatable, Identifiable {

  /// 회원 식별자
  public let id: Int

  /// 닉네임
  public let nickName: String

  /// 한줄소개
  public let introduction: String

  /// 이미지 주소
  public let imageURL: String

  /// 좋아요 수
  public let likeCount: Int

  /// 싫어요 수
  public let disLikeCount: Int

  /// 차단 여부
  public let blocked: Bool
}
