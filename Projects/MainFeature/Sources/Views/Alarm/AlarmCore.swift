import Foundation
import ComposableArchitecture

import Core

public struct AlarmCore: Reducer {
  public struct State: Equatable {
    var alarms = [Alarm]()
    var model: AppState.AlarmModel?
    
    public init(model: AppState.AlarmModel? = nil) {
      self.model = model
    }
  }
  
  public enum Action: Equatable {
    case delegate(Delegate)
    
    case listTapped(Alarm)
    case swipeDelete(IndexSet)
    
    case _requestVote
    case _requestAlarmList
    case _alarmListResponse(TaskResult<[Alarm]>)
    
    public enum Delegate: Equatable {
      case pushTarget(Vote, AppState.AlarmModel)
    }
  }
  
  @Dependency(\.toastManager) var toast
  @Dependency(\.notificationRepository) var notiRepo
  @Dependency(\.voteRepository) var voteRepo
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate: break
        
      case let .listTapped(alarm):
        let model = AppState.AlarmModel(
          voteID: alarm.voteID,
          commentID: alarm.commentID,
          alarmID: alarm.id,
          step: .alarm
        )
        
        return .run { send in
          let vote = try await voteRepo.getVote(id: model.voteID)
          try await notiRepo.readAlarm(id: model.alarmID)
          await send(.delegate(.pushTarget(vote, model)))
        }
        
      case ._requestVote:
        guard let model = state.model else { return .none}
        
        return .run { send in
          let vote = try await voteRepo.getVote(id: model.voteID)
          await send(.delegate(.pushTarget(vote, model)))
        }
        
      case let .swipeDelete(indexSet):
        guard let index = indexSet.first else {
          return .none
        }
        
        let targetID = state.alarms[index].id
        state.alarms.remove(atOffsets: indexSet)

        return .run { send in
          try await notiRepo.deleteAlarm(id: targetID)
        } catch: { error, send in
          await toast.showToast(.error("알람 삭제에 실패했어요"))
        }
        
      case ._requestAlarmList:
        return .run { send in
          await send(._alarmListResponse(TaskResult {
            return try await notiRepo.requestAlarmList()
          }))
        }
        
      case let ._alarmListResponse(.success(alarms)):
        state.alarms = alarms.reversed()
        
      case let ._alarmListResponse(.failure(error)):
        
        print(error.localizedDescription)
      }
      
      return .none
    }
  }
}
