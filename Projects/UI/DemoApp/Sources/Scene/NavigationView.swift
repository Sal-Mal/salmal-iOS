import SwiftUI
import UI

struct NavigationView: View {
  var body: some View {
    VStack {
      NavigationLink("MainNavigationBar") {
        MainView()
      }
      
      NavigationLink("NavigationBar") {
        DefaultView()
      }
    }
  }
}

private struct MainView: View {
  @Environment(\.dismiss) var dismiss
  @State var selection: SMMainNavigationBar.Tab = .home
  
  var body: some View {
    Rectangle().fill(.red)
      .overlay(
        Button("Back") {
          dismiss()
        }
        .buttonStyle(.borderedProminent)
      )
      .smMainNavigationBar(selection: $selection, isAlarmExist: true) {
        
      }
  }
}

private struct DefaultView: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    Rectangle().fill(.red)
      .smNavigationBar(title: "second") {
        Image(icon: .chevron_left)
          .fit(size: 32, renderingMode: .template, color: .ds(.white))
          .onTapGesture {
            dismiss()
          }
          
      } rightItems: {
        Text("확인")
          .navigationItem(color: .ds(.green1))
      }
  }
}


struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      NavigationView()
        .navigationTitle("")
    }
  }
}
