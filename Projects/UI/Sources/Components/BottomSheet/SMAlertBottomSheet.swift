import SwiftUI

public enum Alert {
  case blocking
  case delete
  case logout
  case withdrawal
  case custom(title: String, content: String, buttonTitle: String)
  
  var title: String {
    switch self {
    case .blocking:
      return "이 사용자를 차단하시겠습니까?"
    case .delete:
      return "삭제하시겠습니까?"
    case .logout:
      return "로그아웃 하시겠습니까?"
    case .withdrawal:
      return "살말 서비스를 탈퇴하시겠습니까?"
    case let .custom(title, _, _):
      return title
    }
  }
  
  var content: String {
    switch self {
    case .blocking:
      return "차단한 사용자의 게시글이 더 이상 보이지 않게 됩니다."
    case .delete:
      return "삭제하시면 복원이 불가능합니다."
    case .logout:
      return "로그아웃시 홈 화면으로 이동합니다"
    case .withdrawal:
      return "탈퇴 시 모든 정보가 사라집니다"
    case let .custom(_, content, _):
      return content
    }
  }
  
  var confirmButtonTitle: String {
    switch self {
    case .blocking:
      return "차단"
    case .delete:
      return "삭제"
    case .logout:
      return "로그아웃하기"
    case .withdrawal:
      return "탈퇴하기"
    case let .custom(_, _, buttonTitle):
      return buttonTitle
    }
  }
}

public extension View {
  func smAlertSheet(
    isPresented: Binding<Bool>,
    alert: Alert,
    confirmAction: @escaping () -> Void
  ) -> some View {
    modifier(SMAlertBottomSheetModifier(
      isPresented: isPresented,
      alert: alert,
      confirmAction: confirmAction
    ))
  }
}

public struct SMAlertBottomSheetModifier: ViewModifier {
  @Binding var isPresented: Bool
  let alert: Alert
  let confirmAction: () -> Void
  
  public func body(content: Content) -> some View {
    content
      .sheet(isPresented: $isPresented) {
        SMAlertBottomSheet(
          alert: alert,
          confirmAction: confirmAction
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
        .background(Color.ds(.gray4))
        .presentationDetents([.height(212)])
        .presentationDragIndicator(.hidden)
      }
  }
}

public struct SMAlertBottomSheet: View {
  let alert: Alert
  let confirmAction: () -> Void
  
  @Environment(\.dismiss) var dismiss
  
  public var body: some View {
    VStack(spacing: 32) {
      SheetDragIndicator()
      
      Spacer()
      
      VStack(spacing: 8) {
        Text(alert.title)
          .foregroundColor(.ds(.white))
          .font(.ds(.title3))
        Text(alert.content)
          .foregroundColor(.ds(.white36))
          .font(.ds(.title4))
      }
      
      HStack(spacing: 13) {
        SMBoxButton(title: "취소", buttonSize: .large) {
          dismiss()
        }
        
        SMBoxButton(title: "확인", buttonSize: .large) {
          confirmAction()
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dismiss()
          }
        }
      }
    }
    .padding(.horizontal, 18)
  }
}

struct SMAlertBottomSheet_Previews: PreviewProvider {
  static var previews: some View {
    @State var dissmiss = false
    RoundedRectangle(cornerRadius: 20).fill(.green)
      .smAlertSheet(
        isPresented: .constant(true),
        alert: .blocking,
        confirmAction: {}
      )
      .previewLayout(.sizeThatFits)
  }
}
