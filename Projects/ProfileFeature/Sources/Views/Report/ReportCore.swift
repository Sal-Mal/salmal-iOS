import UI
import Core
import ComposableArchitecture

public struct ReportCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
    let memberID: Int
    let items: [MenuItem] = [
      .init(icon: .init(icon: .ic_warning), title: "해당 게시물 신고하기"),
      .init(icon: .init(icon: .ic_cancel), title: "이 사용자 차단하기")
    ]
    
    public init(voteID: Int, memberID: Int) {
      self.voteID = voteID
      self.memberID = memberID
    }
  }
  
  public enum Action: Equatable {
    case tap(index: Int)
  }
  
  public init() {
    
  }
  
  @Dependency(\.toastManager) var toastManager
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.memberRepository) var memberRepository
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let .tap(index):
        switch index {
        case 0:
          return .run { [id = state.voteID] send in
            try await voteRepository.report(voteID: id)
            await toastManager.showToast(.success("해당 게시물을 신고했어요"))
            
            await dismiss()
          } catch: { error, send in
            await toastManager.showToast(.error("게시물 신고 실패"))
            await dismiss()
          }
        case 1:
          return .run { [id = state.memberID] send in
            try await memberRepository.block(id: id)
            await toastManager.showToast(.success("해당 유저를 차단했어요"))
            await dismiss()
          } catch: { error, send in
            await toastManager.showToast(.error("유저 차단 실패"))
            await dismiss()
          }
          
        default:
          return .none
        }
      }
    }
  }
}
