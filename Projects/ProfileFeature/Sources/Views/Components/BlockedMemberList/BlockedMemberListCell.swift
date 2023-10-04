import SwiftUI

import Core

public struct BlockedMemberListCell: View {

  private let member: Member
  private let action: () -> Void

  public init(member: Member, action: @escaping () -> Void) {
    self.member = member
    self.action = action
  }

  public var body: some View {
    HStack {
      HStack(spacing: 12) {
        AsyncImage(url: URL(string: member.imageURL))
          .frame(width: 48, height: 48)
          .aspectRatio(1, contentMode: .fit)
          .clipShape(Circle())

        Text(member.nickName)
          .font(.ds(.title4(.semibold)))
      }

      Spacer()

      Button {
        action()
      } label: {
        Text("차단 해제")
          .font(.ds(.title4(.medium)))
          .foregroundColor(.ds(.black))
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .background(Color.ds(.green1))
          .clipShape(Capsule())
      }
    }
  }
}
