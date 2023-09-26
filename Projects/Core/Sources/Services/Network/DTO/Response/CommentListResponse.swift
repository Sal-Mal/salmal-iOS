import Foundation

public struct CommentListResponse: Responsable {
  public let hashNext: Bool
  public let comments: [CommentResponse]
  
  public static var mock: CommentListResponse {
    .init(hashNext: true, comments: [
      CommentResponse.mock,
      CommentResponse.mock,
      CommentResponse.mock
    ])
  }
}

public struct CommentResponse: Responsable {
  let id: Int
  let memberId: Int
  let memberImageUrl: String
  let content: String
  let liked: Bool
  let likeCount: Int
  let createdAt: Date
  let updatedAt: Date
  let replys: [ReplyResponse]
  
  public static var mock: CommentResponse {
    .init(
      id: (0...10).randomElement()!,
      memberId: (0...10).randomElement()!,
      memberImageUrl: "https://picsum.photos/100",
      content: "농부룩 같아요...!!!",
      liked: Bool.random(),
      likeCount: (0...100).randomElement()!,
      createdAt: .now,
      updatedAt: .now,
      replys: [
        .mock, .mock, .mock, .mock
      ]
    )
  }
  
  public var toDomain: Comment {
    .init(
      id: id,
      memberId: memberId,
      memberImageUrl: memberImageUrl,
      content: content,
      liked: liked,
      likeCount: likeCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      replys: replys.map(\.toDomain)
    )
  }
}

public struct ReplyResponse: Responsable {
  let id: Int
  let memberId: Int
  let memberImageUrl: String
  let content: String
  let liked: Bool
  let likeCount: Int
  let createdDate: Date
  let updatedDate: Date
  
  public static var mock: ReplyResponse {
    .init(
      id: (0...10).randomElement()!,
      memberId: (0...10).randomElement()!,
      memberImageUrl: "https://picsum.photos/100",
      content: "농부룩 같아요...",
      liked: Bool.random(),
      likeCount: (0...100).randomElement()!,
      createdDate: .now,
      updatedDate: .now
    )
  }
  
  public var toDomain: ReplyComment {
    .init(
      id: id,
      memberId: memberId,
      memberImageUrl: memberImageUrl,
      content: content,
      liked: liked,
      likeCount: likeCount,
      createdDate: createdDate,
      updatedDate: updatedDate
    )
  }
}
