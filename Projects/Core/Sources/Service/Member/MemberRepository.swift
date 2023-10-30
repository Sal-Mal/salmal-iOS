import Foundation
import ComposableArchitecture

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
  func blocks(cursorId: Int?, size: Int) async throws -> MemberPage
  /// 회원이 작성한 투표 목록 조회
  func votes(memberID: Int, cursorId: Int?, size: Int) async throws -> [Vote]
  /// 회원이 투표한 목록 조회
  func evaluations(cursorId: Int, size: Int) async throws -> [Vote]
  /// 회원이 북마크한 목록 조회
  func bookmarks(cursorId: Int, size: Int) async throws -> [Vote]
}


public final class MemberRepositoryImpl: MemberRepository {

  private let networkManager: NetworkService

  @Dependency(\.userDefault) var userDefault

  public init(networkManager: NetworkService) {
    self.networkManager = networkManager
  }

  public func member(id: Int) async throws -> Member {
    let target = MemberAPI.fetch(id: id)
    let response = try await networkManager.request(target, type: MemberResponseDTO.self)
    return response.toDomain
  }

  public func myPage() async throws -> Member {
    guard let id = userDefault.memberID else {
      throw SMError.network(.default)
    }

    let target = MemberAPI.fetch(id: id)
    let response = try await networkManager.request(target, type: MemberResponseDTO.self)
    return response.toDomain
  }

  public func update(nickname: String, introduction: String) async throws {
    guard let id = userDefault.memberID else {
      throw SMError.network(.default)
    }

    let target = MemberAPI.update(id: id, nickName: nickname, introduction: introduction)
    try await networkManager.request(target)
  }

  public func updateImage(data: Data) async throws {
    guard let id = userDefault.memberID else {
      throw SMError.network(.default)
    }

    let target = MemberAPI.updateImage(id: id, data: data)
    try await networkManager.request(target)
  }

  public func delete() async throws {
    guard let id = userDefault.memberID else {
      throw SMError.network(.default)
    }

    let target = MemberAPI.delete(id: id)
    try await networkManager.request(target)
    
    userDefault.accessToken = nil
    userDefault.refreshToken = nil
    userDefault.socialID = nil
    userDefault.socialProvider = nil
  }

  public func block(id: Int) async throws {
    let target = MemberAPI.block(id: id)
    try await networkManager.request(target)
  }

  public func unBlock(id: Int) async throws {
    let target = MemberAPI.unBlock(id: id)
    try await networkManager.request(target)
  }

  public func blocks(cursorId: Int?, size: Int) async throws -> MemberPage {
    guard let id = userDefault.memberID else {
      throw SMError.network(.default)
    }

    let target = MemberAPI.fetchBlocks(id: id, cursorId: cursorId, size: size)
    let response = try await networkManager.request(target, type: BlockedMemberListResponseDTO.self)
    return MemberPage(hasNext: response.hasNext, members: response.members.map { $0.toDomain })
  }

  public func votes(memberID: Int, cursorId: Int?, size: Int) async throws -> [Vote] {
    let target = MemberAPI.fetchVotes(id: memberID, cursorId: cursorId, size: size)
    let response = try await networkManager.request(target, type: VoteListResponseDTO.self)
    return response.votes.map { $0.toDomain }
  }

  public func evaluations(cursorId: Int, size: Int) async throws -> [Vote] {
    guard let id = userDefault.memberID else {
      throw SMError.network(.default)
    }

    let target = MemberAPI.fetchEvaluations(id: id, cursorId: cursorId, size: size)
    let response = try await networkManager.request(target, type: VoteListResponseDTO.self)
    return response.votes.map { $0.toDomain }
  }

  public func bookmarks(cursorId: Int, size: Int) async throws -> [Vote] {
    guard let id = userDefault.memberID else {
      throw SMError.network(.default)
    }

    let target = MemberAPI.fetchBookmarks(id: id, cursorId: cursorId, size: size)
    let response = try await networkManager.request(target, type: VoteListResponseDTO.self)
    return response.votes.map { $0.toDomain }
  }
}

public enum MemberRepositoryKey: DependencyKey {
  public static let liveValue: any MemberRepository = MemberRepositoryImpl(networkManager: DefaultNetworkService())
}

public extension DependencyValues {

  var memberRepository: MemberRepository {
    get { self[MemberRepositoryKey.self] }
    set { self[MemberRepositoryKey.self] = newValue }
  }
}
