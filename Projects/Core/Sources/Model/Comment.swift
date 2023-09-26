import Foundation

public struct Comment: Equatable {
  let id: Int
  let memberId: Int
  let memberImageUrl: String
  let content: String
  let liked: Bool
  let likeCount: Int
  let createdAt: Date
  let updatedAt: Date
  let replys: [Reply]
}

public struct Reply: Equatable
{
  let id: Int
  let memberId: Int
  let memberImageUrl: String
  let content: String
  let liked: Bool
  let likeCount: Int
  let createdDate: Date
  let updatedDate: Date
}
