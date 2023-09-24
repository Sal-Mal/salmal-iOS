import Foundation

public struct UpdateMemberDTO: Encodable {
  public let nickName: String
  public let introduction: String
  public let imageUrl: String
}
