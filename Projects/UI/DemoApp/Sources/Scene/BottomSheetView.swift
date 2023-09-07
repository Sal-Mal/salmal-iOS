import SwiftUI
import UI

struct BottomSheetView: View {
  @State var showAlert: Bool = false
  @State var showList: Bool = false
  
  var body: some View {
    VStack {
      Button {
        showAlert.toggle()
      } label: {
        Text("얼럿").frame(width: 100)
      }

      Button {
        showList.toggle()
      } label: {
        Text("리스트").frame(width: 100)
      }
    }
    .buttonStyle(.borderedProminent)
    
    .smAlertSheet(isPresented: $showAlert, alert: .blocking) {
      print("!!")
    }
    .smListSheet(
      isPresented: $showList,
      items: [.사진첩에서_선택하기, .이_사용자_차단하기],
      actions: [{ print("선택하기") }, { print("차단하기") }]
    )
  }
}

struct BottomSheetView_Previews: PreviewProvider {
  static var previews: some View {
    BottomSheetView()
  }
}
