import Foundation

public struct Alarm: Equatable, Identifiable {
  public let id: String
  public let commentID: Int // 댓글 ID
  public let voteID: Int // 투표 ID
  public let type: String // 컨텐츠 타입
  public let message: String // 알림 본문
  public let createdAt: String // 생성시간 YY-MM-DDThh:mm:ss
  public let memberImageURL: String // 맴버 프로필 url
  public let voteImageURL: String // 투표 이미지 url
  public let isRead: Bool // 읽었는지 여부
}
