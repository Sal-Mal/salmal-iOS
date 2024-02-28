import UI
import Core
import ComposableArchitecture

public struct ReportCore: Reducer {
  public struct State: Equatable {
    @PresentationState var alert: AlertState<Action.Alert>?
    @PresentationState var confirmDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    
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
    case _alert(PresentationAction<Alert>)
    case _confirmDialog(PresentationAction<ConfirmationDialog>)
    case _setAlert(String)
    
    case tap(index: Int)
    
    public enum Alert: Equatable {
      case confirm
    }
    
    public enum ConfirmationDialog: Equatable {
      case badWord
      case copyright
      case pornography
      case advertisement
      case etc
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
      case ._alert(.presented(.confirm)):
        return .run { send in
          await dismiss()
        }
      
      case ._alert: break
        
      case ._confirmDialog(.presented):
          return .run { [id = state.voteID] send in
            try await voteRepository.report(voteID: id)
            await send(._setAlert("신고 처리가 완료되었습니다.\n24시간 이내에 검토 후 삭제 조치될 예정입니다."))
          } catch: { error, send in
            if let error = error as? SMError,
               case let .network(.invalidURLHTTPResponse(code)) = error,
               code == 3006
            {
              await send(._setAlert("이미 신고한 게시글입니다"))
            } else {
              await toastManager.showToast(.error("게시물 신고 실패"))
              await dismiss()
            }
          }
        
      case ._confirmDialog:
        break
        
      case let ._setAlert(message):
        state.alert = AlertState {
          TextState("")
        } actions: {
          ButtonState(action: .confirm) {
            TextState("확인")
          }
        } message: {
          TextState(message)
        }
        
      case let .tap(index):
        switch index {
        case 0:
          state.confirmDialog = ConfirmationDialogState {
            TextState("")
          } actions: {
            ButtonState(role: .cancel) {
              TextState("취소")
            }
            
            ButtonState(action: .badWord) {
              TextState("욕설/인신공격/비방")
            }
            
            ButtonState(action: .copyright) {
              TextState("개인정보/저작권 침해")
            }
            
            ButtonState(action: .pornography) {
              TextState("음란성/선정성 게시물")
            }
            
            ButtonState(action: .advertisement) {
              TextState("영리목적/홍보성 게시물")
            }
            
            ButtonState(action: .etc) {
              TextState("기타")
            }
          } message: {
            TextState("신고 이유")
          }
        case 1:
          return .run { [id = state.memberID] send in
            try await memberRepository.block(id: id)
            await send(._setAlert("해당 유저를 차단했어요.\n더 이상 해당 유저의 게시글이 피드에 보이지 않아요"))
          } catch: { error, send in
            await toastManager.showToast(.error("유저 차단 실패"))
            await dismiss()
          }
          
        default: break
        }
      }
      
      return .none
    }
    .ifLet(\.$alert, action: /Action._alert)
    .ifLet(\.$confirmDialog, action: /Action._confirmDialog)
  }
}
