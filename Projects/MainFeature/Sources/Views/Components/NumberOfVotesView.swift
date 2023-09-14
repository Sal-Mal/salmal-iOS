import SwiftUI

import UI

struct NumberOfVotesView: View {
  let number: Int
  
  init(number: Int) {
    self.number = number
  }
  
  var body: some View {
    Text("🔥 현재 \(number)명 참여중!")
      .font(.ds(.title4(.medium))) // TODO: Font
      .foregroundColor(.ds(.white))
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(
        Capsule().fill(Color.ds(.black))
      )
      .overlay(
        Capsule().stroke(Color.ds(.green1), lineWidth: 1)
          .shadow(color: .ds(.green1), radius: 1)
      )
      .animation(.default, value: number)
  }
}

struct NumberOfVotesView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      NumberOfVotesView(number: 1200)
      NumberOfVotesView(number: 10)
    }
    .previewLayout(.sizeThatFits)
  }
}

