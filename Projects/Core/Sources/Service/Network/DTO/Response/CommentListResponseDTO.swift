import Foundation

public struct CommentListResponseDTO: Responsable {
  public let hasNext: Bool
  public let comments: [CommentResponseDTO]
  
  public static var mock: CommentListResponseDTO {
    .init(hasNext: true, comments: [
      CommentResponseDTO.mock,
      CommentResponseDTO.mock,
      CommentResponseDTO.mock,
      CommentResponseDTO.mock,
      CommentResponseDTO.mock,
      CommentResponseDTO.mock,
      CommentResponseDTO.mock,
      CommentResponseDTO.mock,
      CommentResponseDTO.mock,
      CommentResponseDTO.mock
    ])
  }
}

public struct CommentResponseDTO: Responsable {
  let id: Int
  let memberId: Int
  let memberImageUrl: String
  let content: String
  let liked: Bool
  let likeCount: Int
  let createdAt: String
  let updatedAt: String
  
  public static var mock: CommentResponseDTO {
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
      createdAt: createdAt.toDate,
      updatedAt: updatedAt.toDate
    )
  }
}

fileprivate extension String {
  var toDate: Date {
    let formatter = DateFormatter()
    // TODO: Locale & TimeZone 설정
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    return formatter.date(from: self) ?? .now
  }
}
