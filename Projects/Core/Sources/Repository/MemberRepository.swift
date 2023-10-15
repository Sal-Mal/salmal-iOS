import Foundation

public protocol MemberRepository {
  /// 회원 조회
  func member(id: Int) async throws -> Member
  /// 마이페이지 조회
  func myPage() async throws -> Member
  /// 마이페이지 수정
  func update(nickname: String, introduction: String) async throws
  /// 회원 이미지 수정
  func updateImage(data: Data) async throws
  /// 회원탈퇴
  func delete() async throws
  /// 회원 차단
  func block(id: Int) async throws
  /// 회원 차단해제
  func unBlock(id: Int) async throws
  /// 회원이 차단한 회원 목록 조회
  func blocks(cursorId: Int, size: Int) async throws -> MemberPage
  /// 회원이 작성한 투표 목록 조회
  func votes(cursorId: Int, size: Int) async throws -> [Vote]
  /// 회원이 투표한 목록 조회
  func evaluations(cursorId: Int, size: Int) async throws -> [Vote]
  /// 회원이 북마크한 목록 조회
  func bookmarks(cursorId: Int, size: Int) async throws -> [Vote]
}


public final class MemberRepositoryImpl: MemberRepository {

  private let networkManager: NetworkManager

  public init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  public func member(id: Int) async throws -> Member {
    let target = MemberAPI.fetch(id: id)
    let response = try await networkManager.request(target, type: MemberResponse.self)
    return response.toDomain
  }

  public func myPage() async throws -> Member {
    let target = MemberAPI.fetch(id: 2)
    let response = try await networkManager.request(target, type: MemberResponse.self)
    return response.toDomain
  }

  public func update(nickname: String, introduction: String) async throws {
    let target = MemberAPI.update(id: 2, nickName: nickname, introduction: introduction)
    try await networkManager.request(target)
  }

  public func updateImage(data: Data) async throws {
    let target = MemberAPI.updateImage(id: 2, data: data)
    try await networkManager.request(target)
  }

  public func delete() async throws {
    let target = MemberAPI.delete(id: 2)
    try await networkManager.request(target)
  }

  public func block(id: Int) async throws {
    let target = MemberAPI.block(id: id)
    try await networkManager.request(target)
  }

  public func unBlock(id: Int) async throws {
    let target = MemberAPI.unBlock(id: 2)
    try await networkManager.request(target)
  }

  public func blocks(cursorId: Int, size: Int) async throws -> MemberPage {
    let target = MemberAPI.fetchBlocks(id: 2, cursorId: cursorId, size: size)
    let response = try await networkManager.request(target, type: BlockedMemberListResponse.self)
    return MemberPage(hasNext: response.hasNext, members: response.members.map { $0.toDomain })
  }

  public func votes(cursorId: Int, size: Int) async throws -> [Vote] {
    let target = MemberAPI.fetchVotes(id: 2, cursorId: cursorId, size: size)
    let response = try await networkManager.request(target, type: VoteListResponse.self)
    return response.votes.map { $0.toDomain }
  }

  public func evaluations(cursorId: Int, size: Int) async throws -> [Vote] {
    let target = MemberAPI.fetchEvaluations(id: 2, cursorId: cursorId, size: size)
    let response = try await networkManager.request(target, type: VoteListResponse.self)
    return response.votes.map { $0.toDomain }
  }

  public func bookmarks(cursorId: Int, size: Int) async throws -> [Vote] {
    let target = MemberAPI.fetchBookmarks(id: 2, cursorId: cursorId, size: size)
    let response = try await networkManager.request(target, type: VoteListResponse.self)
    return response.votes.map { $0.toDomain }
  }
}
