import SwiftUI
import ComposableArchitecture

import Core
import UI
import Kingfisher

public struct OtherProfileView: View {

  private let columns = [GridItem(.flexible()), GridItem(.flexible())]
  private let store: StoreOf<OtherProfileCore>

  public init(store: StoreOf<OtherProfileCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { (viewStore: ViewStoreOf<OtherProfileCore>) in
      VStack(spacing: 0) {
        VStack(spacing: 0) {
          ZStack {
            if viewStore.isHeaderFolded {
              foldedHeaderView
                .transition(.opacity)

            } else {
              unFoldedHeaderView
                .transition(.opacity)
            }
          }
          .frame(maxWidth: .infinity)
          .background(Color.ds(.green1))
          .cornerRadius(30)

          if !viewStore.isHeaderFolded {
            Spacer().frame(height: 46)
            HStack {
              Text("업로드")
                .foregroundColor(.ds(.white))
                .font(.ds(.title2(.semibold)))

              Spacer()
            }
            .transition(.opacity)
          }

          VStack {
            Spacer().frame(height: 16)

            SMScrollView(showIndicators: false, onOffsetChanged: viewStore.$scrollViewOffset) {
              LazyVGrid(columns: columns) {
                ForEach(viewStore.votes) { vote in
                  ProfileCell(imageURL: vote.imageURL) {
                    viewStore.send(.voteCellTapped(vote))
                  }
                  .onAppear {
                    viewStore.send(._onScrollViewAppear(vote), animation: .default)
                  }
                }

                Spacer()
              }
            }
            .onAppear {
              UIScrollView.appearance().bounces = false
            }
            .onDisappear {
              UIScrollView.appearance().bounces = true
            }
          }
        }
        .animation(.spring(), value: viewStore.isHeaderFolded)
      }
      .padding(.top, 9)
      .padding(.horizontal, 18)
      .smNavigationBar(
        title: "",
        leftItems: {
          Button {
            viewStore.send(.backButtonTapped)
          } label: {
            Image(icon: .chevron_left)
          }
        },
        rightItems: {
          if viewStore.member?.blocked == true {
            Button {
              viewStore.send(.unBlockButtonTapped)
            } label: {
              Text("차단 해제")
                .font(.ds(.title3(.medium)))
                .foregroundColor(.ds(.white))
            }

          } else {
            Button {
              viewStore.send(.blockButtonTapped)
            } label: {
              Text("차단")
                .font(.ds(.title3(.medium)))
                .foregroundColor(.ds(.white))
            }
          }
        }
      )
      .onAppear {
        viewStore.send(._onAppear)
        NotificationService.post(.hideTabBar)
      }
      .alert(isPresented: viewStore.$isBlockSheetPresented, alert: .blocking) {
        viewStore.send(.blockSheetConfirmButtonTapped)
      }
    }
  }

  var unFoldedHeaderView: some View {
    WithViewStore(store, observe: { $0.member }) { viewStore in
      VStack(spacing: 0) {
        Spacer().frame(height: 29)

        KFImage(URL(string: viewStore.state?.imageURL ?? ""))
          .placeholder {
            defaultProfileImage(size: 80)
          }
          .resizable()
          .scaledToFill()
          .frame(width: 80, height: 80)
          .clipShape(Circle())
          .overlay {
            Circle()
              .stroke(lineWidth: 2)
              .foregroundColor(.white)
          }

        Spacer().frame(height: 16)

        VStack(spacing: 6) {
          Text(viewStore.state?.nickName ?? "비회원")
            .font(.ds(.title3(.semibold)))
            .foregroundColor(.ds(.black))

          Text(viewStore.state?.introduction ?? "비회원 사용자입니다")
            .font(.ds(.title4(.medium)))
            .foregroundColor(.ds(.black))
        }

        Spacer().frame(height: 29)

        HStack(spacing: 62) {
          HStack {
            Text("👍🏻살")
              .font(.pretendard(.semiBold, size: 14))
              .foregroundColor(.ds(.green1))
              .padding(.vertical, 4)
              .padding(.horizontal, 6)
              .background(Color.ds(.black))
              .clipShape(Capsule())

            Text("\(viewStore.state?.likeCount ?? 0)")
              .font(.ds(.title2(.semibold)))
              .foregroundColor(.ds(.black))
          }

          HStack {
            Text("👎🏻말")
              .font(.pretendard(.semiBold, size: 14))
              .foregroundColor(.ds(.green1))
              .padding(.vertical, 4)
              .padding(.horizontal, 6)
              .background(Color.ds(.black))
              .clipShape(Capsule())

            Text("\(viewStore.state?.disLikeCount ?? 0)")
              .font(.ds(.title2(.semibold)))
              .foregroundColor(.ds(.black))
          }
        }

        Spacer().frame(height: 32)
      }
    }
  }

  var foldedHeaderView: some View {
    WithViewStore(store, observe: { $0.member }) { viewStore in
      HStack(spacing: 0) {
        KFImage(URL(string: viewStore.state?.imageURL ?? ""))
          .placeholder {
            defaultProfileImage(size: 60)
          }
          .resizable()
          .scaledToFill()
          .frame(width: 60, height: 60)
          .clipShape(Circle())
          .overlay {
            Circle()
              .stroke(lineWidth: 2)
              .foregroundColor(.white)
          }

        Spacer().frame(width: 16)

        HStack {
          VStack(alignment: .leading, spacing: 8) {
            Text(viewStore.state?.nickName ?? "비회원")
              .font(.ds(.title3(.semibold)))
              .foregroundColor(.ds(.black))

            HStack(spacing: 16) {
              HStack {
                Text("👍🏻살")
                  .font(.pretendard(.semiBold, size: 14))
                  .foregroundColor(.ds(.green1))
                  .padding(.vertical, 4)
                  .padding(.horizontal, 6)
                  .background(Color.ds(.black))
                  .clipShape(Capsule())

                Text("\(viewStore.state?.likeCount ?? 0)")
                  .font(.ds(.title2(.semibold)))
                  .foregroundColor(.ds(.black))
              }

              HStack {
                Text("👎🏻말")
                  .font(.pretendard(.semiBold, size: 14))
                  .foregroundColor(.ds(.green1))
                  .padding(.vertical, 4)
                  .padding(.horizontal, 6)
                  .background(Color.ds(.black))
                  .clipShape(Capsule())

                Text("\(viewStore.state?.disLikeCount ?? 0)")
                  .font(.ds(.title2(.semibold)))
                  .foregroundColor(.ds(.black))
              }
            }
          }

          Spacer()
        }
      }
      .padding(.vertical, 18)
      .padding(.horizontal, 24)
      .frame(maxWidth: .infinity)
      .background(Color.ds(.green1))
      .cornerRadius(30)
    }
  }

  func defaultProfileImage(size: CGFloat) -> some View {
    Image(icon: .person_fill)
      .resizable()
      .frame(width: size / 2, height: size / 2)
      .aspectRatio(contentMode: .fit)
      .frame(width: size, height: size)
      .background(.gray)
      .clipShape(Circle())
      .overlay {
        Circle()
          .stroke(lineWidth: 2)
          .foregroundColor(.ds(.white))
      }
  }
}


struct OtherProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      OtherProfileView(store: .init(initialState: .init(memberID: 1), reducer: {
        OtherProfileCore()._printChanges()
      }))
    }
    .preferredColorScheme(.dark)
  }
}
