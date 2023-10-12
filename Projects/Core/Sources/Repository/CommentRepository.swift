import ComposableArchitecture

public protocol CommentRepository {
  func list(id: Int) async throws -> [Comment]
  func write(id: Int, text: String) async throws
  func edit(id: Int, text: String) async throws
  func delete(id: Int) async throws
  func like(id: Int) async throws
  func disLike(id: Int) async throws
  func report(id: Int) async throws
}

public final class CommentRepositoryImpl: CommentRepository {
  let networkManager: NetworkManager
  
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
  
  public func list(id: Int) async throws -> [Comment] {
    let target = CommentAPI.list(id: id)
    let dto = try await networkManager.request(target, type: CommentListResponse.self)
    return dto.comments.map(\.toDomain)
  }
  
  public func write(id: Int, text: String) async throws {
    let target = CommentAPI.write(id: id, text: text)
    try await networkManager.request(target, type: EmptyEntity.self)
  }
  
  public func edit(id: Int, text: String) async throws {
    let target = CommentAPI.edit(id: id, text: text)
    try await networkManager.request(target)
  }
  
  public func delete(id: Int) async throws {
    let target = CommentAPI.delete(id: id)
    try await networkManager.request(target)
  }
  
  public func like(id: Int) async throws {
    let target = CommentAPI.like(id: id)
    try await networkManager.request(target)
  }
  
  public func disLike(id: Int) async throws {
    let target = CommentAPI.disLike(id: id)
    try await networkManager.request(target)
  }
  
  public func report(id: Int) async throws {
    let target = CommentAPI.report(id: id)
    try await networkManager.request(target)
  }
}

/// TCA DependencyKey를 정의
public enum CommentRepositoryKey: DependencyKey {
  public static let liveValue: any CommentRepository = CommentRepositoryImpl(networkManager: LiveNetworkManager())
  public static let previewValue: any CommentRepository = CommentRepositoryImpl(networkManager: MockNetworkManager())
  public static let testValue: any CommentRepository = CommentRepositoryImpl(networkManager: MockNetworkManager())
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var commentRepository: CommentRepository {
    get { self[CommentRepositoryKey.self] }
    set { self[CommentRepositoryKey.self] = newValue }
  }
}
