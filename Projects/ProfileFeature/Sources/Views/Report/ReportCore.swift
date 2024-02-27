import UI
import Core
import ComposableArchitecture

public struct ReportCore: Reducer {
  public struct State: Equatable {
    @PresentationState var alert: AlertState<Action.Alert>?
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
    case alert(PresentationAction<Alert>)
    case setAlert(String)
    case tap(index: Int)
    
    public enum Alert {
      case tapConfirmButton
    }
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
      case .alert(.presented(.tapConfirmButton)):
        return .run { send in
          await dismiss()
        }
      
      case .alert:
        return .none
        
      case let .setAlert(message):
        state.alert = AlertState {
          TextState("")
        } actions: {
          ButtonState(action: .tapConfirmButton) {
            TextState("확인")
          }
        } message: {
          TextState(message)
        }
        
        return .none
      case let .tap(index):
        switch index {
        case 0:
          return .run { [id = state.voteID] send in
            try await voteRepository.report(voteID: id)
            await send(.setAlert("신고 처리가 완료되었습니다.\n24시간 이내에 검토 후 삭제 조치될 예정입니다."))
          } catch: { error, send in
            await toastManager.showToast(.error("게시물 신고 실패"))
            await dismiss()
          }
        case 1:
          return .run { [id = state.memberID] send in
            try await memberRepository.block(id: id)
            await send(.setAlert("해당 유저를 차단했어요.\n더 이상 해당 유저의 게시글이 피드에 보이지 않아요"))
          } catch: { error, send in
            await toastManager.showToast(.error("유저 차단 실패"))
            await dismiss()
          }
          
        default:
          return .none
        }
      }
    }
    .ifLet(\.$alert, action: /Action.alert)
  }
}
