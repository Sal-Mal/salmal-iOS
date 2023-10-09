import Foundation

public struct MemberPage: Equatable, Identifiable {
  public let id: UUID = .init()
  public let hasNext: Bool
  public let members: [Member]
}
