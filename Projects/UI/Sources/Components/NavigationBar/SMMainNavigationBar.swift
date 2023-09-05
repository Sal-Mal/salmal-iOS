import SwiftUI

public struct SMMainNavigationBar: ViewModifier {
  @Binding var selection: Int
  let color: Color
  let profileImage: Image
  let addAction: () -> Void
  let profileAction: () -> Void
  
  public init(
    selection: Binding<Int>,
    color: Color,
    profileImage: Image,
    addAction: @escaping () -> Void,
    profileAction: @escaping () -> Void
  ) {
    self._selection = selection
    self.color = color
    self.profileImage = profileImage
    self.addAction = addAction
    self.profileAction = profileAction
  }
  
  public func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Text("Home")
            .font(.title2).bold()
            .foregroundColor(selection == 0 ? .ds(.green1) : .ds(.white36))
            .onTapGesture {
              withAnimation {
                selection = 0
              }
            }
        }

        ToolbarItem(placement: .navigationBarLeading) {
          Text("Best")
            .font(.title2).bold()
            .foregroundColor(selection == 1 ? .ds(.green1) : .ds(.white36))
            .onTapGesture {
              withAnimation {
                selection = 1
              }
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Circle().fill(Color.ds(.green1))
            .frame(width: 32)
            .overlay(
              Image(icon: .plus)
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(.ds(.black))
                .frame(width: 10)
            )
            .onTapGesture(perform: addAction)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          profileImage
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .clipShape(Circle())
            .onTapGesture(perform: profileAction)
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
    selection: Binding<Int>,
    color: Color = .ds(.black),
    profile: Image,
    addAction: @escaping () -> Void,
    profileAction: @escaping () -> Void
  ) -> some View{
    modifier(SMMainNavigationBar(
      selection: selection,
      color: color,
      profileImage: profile,
      addAction: addAction,
      profileAction: profileAction
    ))
  }
}
