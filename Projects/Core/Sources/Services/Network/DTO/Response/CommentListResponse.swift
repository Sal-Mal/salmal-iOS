import Foundation

public struct CommentListResponse: Responsable {
  public let hasNext: Bool
  public let comments: [CommentResponse]
  
  public static var mock: CommentListResponse {
    .init(hasNext: true, comments: [
      CommentResponse.mock,
      CommentResponse.mock,
      CommentResponse.mock,
      CommentResponse.mock,
      CommentResponse.mock,
      CommentResponse.mock,
      CommentResponse.mock,
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
  let createdAt: String
  let updatedAt: String
  
  public static var mock: CommentResponse {
    .init(
      id: (0...10000).randomElement()!,
      memberId: (0...10000).randomElement()!,
      memberImageUrl: "https://picsum.photos/100",
      content: "농부룩 같아요...!!!",
      liked: Bool.random(),
      likeCount: (0...100).randomElement()!,
      createdAt: "2023-10-12T11:43:31.299933",
      updatedAt: "2023-10-12T11:43:31.299933"
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
      updatedAt: updatedAt
    )
  }
}
