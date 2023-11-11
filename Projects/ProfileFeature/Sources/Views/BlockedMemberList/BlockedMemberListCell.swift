import SwiftUI

import UI
import Core

struct BlockedMemberListCell: View {

  private let member: Member
  private let action: () -> Void
  private let buttonAction: () -> Void

  init(member: Member, action: @escaping () -> Void, buttonAction: @escaping () -> Void) {
    self.member = member
    self.action = action
    self.buttonAction = buttonAction
  }

  var body: some View {
    HStack(spacing: 18) {
      HStack(spacing: 12) {
        if let imageURL = URL(string: member.imageURL) {
          CacheAsyncImage(url: imageURL) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .frame(width: 48, height: 48)
                .scaledToFit()
                .clipShape(Circle())

            default:
              defaultImage
            }
          }
        } else {
          defaultImage
        }

        Text(member.nickName)
          .font(.ds(.title4(.semibold)))

        Spacer()
      }
      .contentShape(Rectangle()) // Spacer 탭 안되는 문제를 해결하기 위함 (Hit Testing)
      .padding(.vertical, 16)
      .onTapGesture {
        action()
      }

      Button {
        buttonAction()
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
    .padding(.horizontal, 18)
    .frame(maxWidth: .infinity)
  }

  private var defaultImage: some View {
    Circle().frame(width: 48, height: 48)
  }
}
