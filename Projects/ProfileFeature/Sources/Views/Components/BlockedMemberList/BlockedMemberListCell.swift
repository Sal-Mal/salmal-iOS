import SwiftUI

import UI
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
        if let url = URL(string: member.imageURL) {
          CacheAsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .frame(width: 48, height: 48)
                .scaledToFit()
                .clipShape(Circle())

            default:
              Circle()
                .frame(width: 48, height: 48)
            }
          }
        } else {
          Circle()
            .frame(width: 48, height: 48)
        }

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
      .buttonStyle(.plain)
    }
  }
}
