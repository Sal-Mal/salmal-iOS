import Combine
import Foundation

public enum NotificationService {
  public enum Noti: String {
    case reportVote
    case banUser
    case login
    case logout
    case tapAddComment
    case showTabBar
    case hideTabBar
    
    var name: Notification.Name {
      return .init(self.rawValue)
    }
  }
  
  static let center = NotificationCenter.default
  
  public static func post(_ noti: Noti, userInfo: [AnyHashable: Any]? = nil) {
    DispatchQueue.main.async {
      center.post(name: noti.name, object: nil, userInfo: userInfo)
    }
  }
  
  public static func publisher(
    _ noti: Noti,
    scheduler: some Scheduler = DispatchQueue.main
  ) -> AnyPublisher<[AnyHashable: Any]?, Never> {
    return center.publisher(for: .init(noti.rawValue))
      .receive(on: scheduler)
      .map(\.userInfo)
      .eraseToAnyPublisher()
  }
}
