import SwiftUI
import UI

struct BottomSheetView: View {
  @State var showAlert: Bool = false
  @State var showCustom: Bool = false
  
  var body: some View {
    VStack {
      Button("Show Alert") {
        showAlert = true
      }
      
      Button("Show Custon") {
        showCustom = true
      }
    }
    .alert(isPresented: $showAlert, alert: .blocking) { /*cofirm Action*/ }
    .bottomSheet(isPresented: $showCustom, content: { Views })
  }
  
  var Views: some View {
    VStack(spacing: 0) {
      ForEach(0..<3, id: \.self) { _ in
        MenuRow(item: .init(icon: Image(icon: .ic_warning), title: "해당 게시물 신고하기"))
      }
    }.padding(.top, 43)
  }
}

struct BottomSheetView_Previews: PreviewProvider {
  static var previews: some View {
    BottomSheetView()
  }
}
