import SwiftUI

public extension View {
  /// Alert 전용 Bottom Sheet
  func alert(
    isPresented: Binding<Bool>,
    alert: SMAlert,
    confirmAction: @escaping () -> Void
  ) -> some View {
    
    modifier(SMBottomSheetModifier(
      isPresented: isPresented,
      innerView: {
        SMAlertView(alert: alert, confirmAction: confirmAction)
      }
    ))
  }
  
  /// 모든 View를 받을 수 있는 Bottom Sheet
  func bottomSheet<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    modifier(SMBottomSheetModifier(
      isPresented: isPresented,
      innerView: content
    ))
  }
}

public struct SMBottomSheetModifier<Inner: View>: ViewModifier {
  @Binding var isPresented: Bool
  let innerView: () -> Inner
  @State var detentHeight: CGFloat = 0
  
  public func body(content: Content) -> some View {
    content
      .sheet(isPresented: $isPresented) {
        innerView()
          .readHeight()
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          .overlay(alignment: .top) {
            SheetDragIndicator().padding(.top, 16)
          }
          .onPreferenceChange(HeightPreferenceKey.self) { height in
            if let height {
              self.detentHeight = height
            }
          }
          .background(Color.ds(.gray4))
          .presentationDetents([.height(detentHeight)])
          .presentationDragIndicator(.hidden)
      }
  }
}

struct BottomSheet_Previews: PreviewProvider {
  static var previews: some View {
    Text("Hello, world!")
      .alert(isPresented: .constant(true), alert: .blocking) { }
  }
}
