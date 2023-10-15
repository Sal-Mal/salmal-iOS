import ComposableArchitecture

public protocol CommentRepository {
  func list(id: Int) async throws -> [Comment]
  func write(voteID: Int, text: String) async throws
  func edit(commentID: Int, text: String) async throws
  func delete(commentID: Int) async throws
  func like(commentID: Int) async throws
  func disLike(commentID: Int) async throws
  func report(commentID: Int) async throws
}

public final class CommentRepositoryImpl: CommentRepository {
  let networkManager: NetworkService
  
  init(networkManager: NetworkService) {
    self.networkManager = networkManager
  }
  
  public func list(id: Int) async throws -> [Comment] {
    let target = CommentAPI.list(id: id)
    let dto = try await networkManager.request(target, type: CommentListResponseDTO.self)
    return dto.comments.map(\.toDomain)
  }
  
  public func write(voteID: Int, text: String) async throws {
    let target = CommentAPI.write(id: voteID, text: text)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func edit(commentID: Int, text: String) async throws {
    let target = CommentAPI.edit(id: commentID, text: text)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func delete(commentID: Int) async throws {
    let target = CommentAPI.delete(id: commentID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func like(commentID: Int) async throws {
    let target = CommentAPI.like(id: commentID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func disLike(commentID: Int) async throws {
    let target = CommentAPI.disLike(id: commentID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
  
  public func report(commentID: Int) async throws {
    let target = CommentAPI.report(id: commentID)
    try await networkManager.request(target, type: EmptyResponseDTO.self)
  }
}

/// TCA DependencyKey를 정의
public enum CommentRepositoryKey: DependencyKey {
  public static let liveValue: any CommentRepository = CommentRepositoryImpl(networkManager: DefaultNetworkService())
  public static let previewValue: any CommentRepository = CommentRepositoryImpl(networkManager: MockNetworkService())
  public static let testValue: any CommentRepository = CommentRepositoryImpl(networkManager: MockNetworkService())
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var commentRepository: CommentRepository {
    get { self[CommentRepositoryKey.self] }
    set { self[CommentRepositoryKey.self] = newValue }
  }
}
