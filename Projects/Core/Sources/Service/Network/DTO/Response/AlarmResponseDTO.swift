import Foundation

public struct AlarmResponseDTO {
  let notifications: [Notification]
  
  struct Notification: Decodable {
    let uuid: String // 알림 고유번호
    let markId: Int // 알림이 발생된 컨텐츠 id (댓글 ID)
    let contentId: Int // 투표아이디
    let type: String // 컨텐츠 타입
    let message: String // 알림 본문
    let createAt: String // 생성시간 YY-MM-DDThh:mm:ss
    let memberImageUrl: String
    let imageUrl: String
    let read: Bool
  }
}

extension AlarmResponseDTO: Responsable {
  public static var mock: AlarmResponseDTO = .init(notifications: [
    .init(
      uuid: UUID().uuidString,
      markId: Int.random(in: 0...300),
      contentId: Int.random(in: 0...300),
      type: "컨텐츠타입1",
      message: "알림본문",
      createAt: "24-01-30T12:00:00",
      memberImageUrl: "https://salmal-image.s3.ap-northeast-2.amazonaws.com/member/default.JPG",
      imageUrl: "https://salmal-image.s3.ap-northeast-2.amazonaws.com/vote/d166e7b5-0f8d-4466-bdf7-36ddb78fc93e/185C4767-1B8D-4981-9CA9-92E2AC7DC296.jpeg",
      read: false
    ),
    .init(
      uuid: UUID().uuidString,
      markId: Int.random(in: 0...300),
      contentId: Int.random(in: 0...300),
      type: "컨텐츠타입2",
      message: "알림본문",
      createAt: "24-01-30T12:00:00",
      memberImageUrl: "https://salmal-image.s3.ap-northeast-2.amazonaws.com/member/default.JPG",
      imageUrl: "https://salmal-image.s3.ap-northeast-2.amazonaws.com/vote/d166e7b5-0f8d-4466-bdf7-36ddb78fc93e/185C4767-1B8D-4981-9CA9-92E2AC7DC296.jpeg",
      read: false
    ),
    .init(
      uuid: UUID().uuidString,
      markId: Int.random(in: 0...300),
      contentId: Int.random(in: 0...300),
      type: "컨텐츠타입3",
      message: "알림본문",
      createAt: "24-01-30T12:00:00",
      memberImageUrl: "https://salmal-image.s3.ap-northeast-2.amazonaws.com/member/default.JPG",
      imageUrl: "https://salmal-image.s3.ap-northeast-2.amazonaws.com/vote/d166e7b5-0f8d-4466-bdf7-36ddb78fc93e/185C4767-1B8D-4981-9CA9-92E2AC7DC296.jpeg",
      read: true
    )
  ])
  
  public var toDomain: [Alarm] {
    self.notifications.map {
      Alarm(
        id: $0.uuid,
        commentID: $0.markId,
        voteID: $0.contentId,
        type: $0.type,
        message: $0.message,
        createdAt: $0.createAt,
        memberImageURL: $0.memberImageUrl,
        voteImageURL: $0.imageUrl,
        isRead: $0.read
      )
    }
  }
}
