import Foundation
import Combine

public final class AppState: ObservableObject {
  
  // Dynamic 링크를 통헤 전달할 데이터
  public struct AlarmModel: Equatable {
    public let voteID: Int // 투표 ID
    public let commentID: Int // 대댓글 ID
    public let alarmID: String
    public var step: Step
    
    public init(voteID: Int, commentID: Int, alarmID: String, step: Step) {
      self.voteID = voteID
      self.commentID = commentID
      self.alarmID = alarmID
      self.step = step
    }
    
    public enum Step: Equatable {
      case home
      case alarm
      case detail
    }
  }
  
  private var cancelBag = Set<AnyCancellable>()
  
  @Published public var showTab = true
  @Published public var alarmData: AlarmModel?
  
  public static let shared = AppState()
  
  private init() {
    NotificationService.publisher(.hideTabBar)
      .sink { [weak self] _  in
        self?.showTab = false
      }
      .store(in: &cancelBag)
    
    NotificationService.publisher(.showTabBar)
      .sink { [weak self] _  in
        self?.showTab = true
      }
      .store(in: &cancelBag)
  }
}
