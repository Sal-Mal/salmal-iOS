import Foundation

public struct UpdateMemberRequest: Encodable {
  public let nickName: String
  public let introduction: String
}
