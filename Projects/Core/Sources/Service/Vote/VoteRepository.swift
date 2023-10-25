import Foundation

import ComposableArchitecture

public protocol VoteRepository {
  func register() async throws
  func evaluate(voteID: Int, param: EvaluateVoteRequestDTO) async throws
  func unEvaluate(voteID: Int) async throws
  func bookmark(voteID: Int) async throws
  func unBookmark(voteID: Int) async throws
  func report(voteID: Int) async throws
  func getVote(id: Int) async throws -> Vote
  func delete(voteID: Int) async throws
  func homeList(size: Int, cursor: Int?, cursorLikes: Int?) async throws -> VoteList
  func bestList(size: Int, cursor: Int?, cursorLikes: Int?) async throws -> VoteList
}

public final class VoteRepositoryImpl: VoteRepository {

  private let networkManager: NetworkService

  @Dependency(\.userDefault) var userDefault

  public init(networkManager: NetworkService) {
    self.networkManager = networkManager
  }
  
  public func register() async throws {
    // TODO: 투표 등록 API
  }
  
  public func evaluate(voteID: Int, param: EvaluateVoteRequestDTO) async throws {
    let target = VoteAPI.vote(id: voteID, param)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func unEvaluate(voteID: Int) async throws {
    let target = VoteAPI.unVote(id: voteID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func bookmark(voteID: Int) async throws {
    let target = VoteAPI.bookmark(id: voteID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func unBookmark(voteID: Int) async throws {
    let target = VoteAPI.unBookmark(id: voteID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func report(voteID: Int) async throws {
    let target = VoteAPI.report(id: voteID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func getVote(id: Int) async throws -> Vote {
    let target = VoteAPI.get(id: id)
    let dto = try await networkManager.request(target, type: VoteResponseDTO.self)
    return dto.toDomain
  }
  
  public func delete(voteID: Int) async throws {
    let target = VoteAPI.delete(id: voteID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }

  public func homeList(size: Int, cursor: Int? = nil, cursorLikes: Int? = nil) async throws -> VoteList {
    let target = VoteAPI.homeList(size: size, cursor: cursor, cursorLikes: cursorLikes)
    let dto = try await networkManager.request(target, type: VoteListResponseDTO.self)
    return dto.toDomain
  }
  
  public func bestList(size: Int, cursor: Int? = nil, cursorLikes: Int? = nil) async throws -> VoteList {
    let target = VoteAPI.bestList(size: size, cursor: cursor, cursorLikes: cursorLikes)
    let dto = try await networkManager.request(target, type: VoteListResponseDTO.self)
    return dto.toDomain
  }
}

/// TCA DependencyKey를 정의
public enum VoteRepositoryKey: DependencyKey {
  public static let liveValue: any VoteRepository = VoteRepositoryImpl(networkManager: DefaultNetworkService())
  public static let previewValue: any VoteRepository = VoteRepositoryImpl(networkManager: MockNetworkService())
  public static let testValue: any VoteRepository = VoteRepositoryImpl(networkManager: MockNetworkService())
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var voteRepository: VoteRepository {
    get { self[VoteRepositoryKey.self] }
    set { self[VoteRepositoryKey.self] = newValue }
  }
}
