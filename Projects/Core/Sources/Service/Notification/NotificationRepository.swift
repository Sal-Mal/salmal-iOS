import Foundation

import ComposableArchitecture

public protocol NotificationRepository {
  func registerFCM(token: String) async throws // 서버에 FCM 토큰 등록
  func requestAlarmList() async throws -> [Alarm] // 알람 리스트 조회
  func deleteAlarm(id: String) async throws // 알람 삭제
  func readAlarm(id: String) async throws // 알람확인
}

public final class NotificationRepositoryImpl: NotificationRepository {
  private let networkManager: NetworkService

  public init(networkManager: NetworkService) {
    self.networkManager = networkManager
  }
  
  public func registerFCM(token: String) async throws {
    let endPoint = NotificationAPI.fcm(.init(token: token))
    try await networkManager.request(endPoint)
  }
  
  public func requestAlarmList() async throws -> [Alarm] {
    let endPoint = NotificationAPI.list
    let dto = try await networkManager.request(endPoint, type: AlarmResponseDTO.self)
    return dto.toDomain
  }
  
  public func deleteAlarm(id: String) async throws {
    let endPoint = NotificationAPI.delete(.init(uuid: id))
    try await networkManager.request(endPoint)
  }
  
  public func readAlarm(id: String) async throws {
    let endPoint = NotificationAPI.read(.init(uuid: id))
    try await networkManager.request(endPoint)
  }
}

/// TCA DependencyKey를 정의
public enum NotificationRepositoryKey: DependencyKey {
  public static let liveValue: any NotificationRepository = NotificationRepositoryImpl(networkManager: DefaultNetworkService())
  public static let previewValue: any NotificationRepository = NotificationRepositoryImpl(networkManager: MockNetworkService())
  public static let testValue: any NotificationRepository = NotificationRepositoryImpl(networkManager: MockNetworkService())
}

/// TCA Dependency에 등록
public extension DependencyValues {
  var notificationRepository: NotificationRepository {
    get { self[NotificationRepositoryKey.self] }
    set { self[NotificationRepositoryKey.self] = newValue }
  }
}
