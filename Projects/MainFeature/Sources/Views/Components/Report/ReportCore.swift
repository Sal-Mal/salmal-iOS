import UI
import Core
import ComposableArchitecture

public struct ReportCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
    let memberID: Int
    let items: [MenuItem] = [
      .init(icon: .init(icon: .warning), title: "해당 게시물 신고하기"),
      .init(icon: .init(icon: .cancel), title: "이 사용자 차단하기")
    ]
  }
  
  public enum Action: Equatable {
    case tap(index: Int)
  }
  
  @Dependency(\.network) var network
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let .tap(index):
        switch index {
        case 0:
          return .run { [id = state.voteID] send in
            try await network.request(VoteAPI.report(id: id))
            NotiManager.post(.reportVote, userInfo: ["id": id])
            // TODO:  토스트 메시지 띄우기
            await dismiss()
          } catch: { error, send in
            // TODO: 에러처리 (토스트)
            await dismiss()
          }
        case 1:
          return .run { [id = state.memberID] send in
            try await network.request(MemberAPI.ban(id: id))
            NotiManager.post(.banUser, userInfo: ["id": id])
            // TODO:  토스트 메시지 띄우기
            await dismiss()
          } catch: { error, send in
            // TODO: 에러처리 (토스트)
            await dismiss()
          }
          
        default:
          return .none
        }
      }
    }
  }
}
