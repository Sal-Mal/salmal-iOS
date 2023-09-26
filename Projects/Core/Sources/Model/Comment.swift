import Foundation

public struct Comment {
  let id: Int
  let content: String
  let createdAt: Date
  let updatedAt: Date
  let replys: [Reply]
}

public struct Reply {
  let id: Int
  let content: String
  let createdDate: Date
  let updatedDate: Date
}
