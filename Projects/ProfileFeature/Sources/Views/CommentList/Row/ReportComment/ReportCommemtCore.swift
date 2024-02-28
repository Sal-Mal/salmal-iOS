import UI
import Core
import ComposableArchitecture

public struct ReportCommentCore: Reducer {
  public struct State: Equatable {
    @PresentationState var alert: AlertState<Action.Alert>?
    @PresentationState var confirmDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    
    let comment: Comment
    
    var isMyComment: Bool {
      return comment.memberId == UserDefaultsService.shared.memberID
    }
    
    var items: [MenuItem] {
      if isMyComment {
        return [
          .init(icon: .init(icon: .ic_pencil), title: "수정"),
          .init(icon: .init(icon: .ic_trash), title: "삭제"),
        ]
      } else {
        return [.init(icon: .init(icon: .ic_warning), title: "신고")]
      }
    }
  }
  
  public enum Action: Equatable {
    case delegate(Delegate)
    case _alert(PresentationAction<Alert>)
    case _confirmDialog(PresentationAction<ConfirmationDialog>)
    
    case _setAlert(String)
    
    case edit
    case delete
    case report
    
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
    
    public enum Delegate: Equatable {
      case refreshList
      case editComment(Comment)
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.commentRepository) var commentRepo
  @Dependency(\.toastManager) var toastManager
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate: break
      
      case ._alert(.presented(.confirm)):
        return .run { send in
          await dismiss()
        }
      
      case ._alert: break
        
      case ._confirmDialog(.presented):
        return .run { [id = state.comment.id] send in
          try await commentRepo.report(commentID: id)
          await send(._setAlert("신고 처리가 완료되었습니다.\n24시간 이내에 검토 후 삭제 조치될 예정입니다."))
        } catch: { error, send in
          if let error = error as? SMError,
             case let .network(.invalidURLHTTPResponse(code)) = error,
             code == 2201
          {
            await send(._setAlert("이미 신고한 댓글입니다"))
          } else {
            await toastManager.showToast(.error("댓글 신고 실패"))
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
        
      case .edit:
        return .run { [state] send in

          await send(.delegate(.editComment(state.comment)))
          await dismiss()
        }
        
      case .delete:
        return .run { [id = state.comment.id] send in
          try await commentRepo.delete(commentID: id)
          await toastManager.showToast(.success("댓글 삭제!"))
          await send(.delegate(.refreshList))
          await dismiss()
        } catch: { error, send in
          await toastManager.showToast(.error("댓글 삭제에 실패했어요. 다시 시도해 주세요"))
        }
        
      case .report:
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
      }
      
      return .none
    }
    .ifLet(\.$alert, action: /Action._alert)
    .ifLet(\.$confirmDialog, action: /Action._confirmDialog)
  }
}
