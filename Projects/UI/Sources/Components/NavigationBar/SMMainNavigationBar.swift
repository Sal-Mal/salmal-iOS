import SwiftUI

public struct SMMainNavigationBar: ViewModifier {
  public enum Tab {
    case home
    case best
  }
  
  @Binding var selection: Tab
  let color: Color
  let isAlarmExist: Bool
  let alarmTapAction: () -> Void
  
  public func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Text("Home")
            .font(.ds(.title))
            .foregroundColor(selection == .home ? .ds(.green1) : .ds(.white36))
            .onTapGesture {
              withAnimation {
                selection = .home
              }
            }
        }

        ToolbarItem(placement: .navigationBarLeading) {
          Text("Best")
            .font(.ds(.title))
            .foregroundColor(selection == .best ? .ds(.green1) : .ds(.white36))
            .onTapGesture {
              withAnimation {
                selection = .best
              }
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Image(icon: isAlarmExist ? .bell_dot_fill : .bell_fill)
            .fit(size: 28)
            .onTapGesture(perform: alarmTapAction)
        }
      }
      .toolbarBackground(color, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
  }
}

public extension View {
  func smMainNavigationBar(
    selection: Binding<SMMainNavigationBar.Tab>,
    color: Color = .ds(.black),
    isAlarmExist: Bool,
    alarmTapAction: @escaping () -> Void
  ) -> some View{
    modifier(SMMainNavigationBar(
      selection: selection,
      color: color,
      isAlarmExist: isAlarmExist,
      alarmTapAction: alarmTapAction
    ))
  }
}

struct SMMainNavigationView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      Text("Hello, world!")
        .smMainNavigationBar(selection: .constant(.home), isAlarmExist: true) {
          
          
        }
    }
  }
}
