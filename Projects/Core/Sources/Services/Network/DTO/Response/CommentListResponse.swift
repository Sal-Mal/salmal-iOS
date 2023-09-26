import Foundation

public struct CommentListResponse: Responsable {
  let hashNext: Bool
  let comments: [CommentResponse]
  
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
  let content: String
  let createdAt: Date
  let updatedAt: Date
  let replys: [ReplyResponse]
  
  public static var mock: CommentResponse {
    .init(
      id: 1,
      content: "농부록 같아요...",
      createdAt: .now,
      updatedAt: .now,
      replys: [
        ReplyResponse.mock,
        ReplyResponse.mock,
        ReplyResponse.mock
      ]
    )
  }
  
  public var toDomain: Comment {
    .init(
      id: id,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      replys: replys.map(\.toDomain)
    )
  }
}

public struct ReplyResponse: Responsable {
  let id: Int
  let content: String
  let createdDate: Date
  let updatedDate: Date
  
  public static var mock: ReplyResponse {
    .init(id: 1, content: "농부록 같아요...", createdDate: .now, updatedDate: .now)
  }
  
  public var toDomain: Reply {
    .init(
      id: id,
      content: content,
      createdDate: createdDate,
      updatedDate: updatedDate
    )
  }
}
