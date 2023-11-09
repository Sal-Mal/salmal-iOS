import SwiftUI
import ComposableArchitecture

import UI

public struct OtherProfileView: View {

  private let columns = [GridItem(.flexible()), GridItem(.flexible())]
  private let store: StoreOf<OtherProfileCore>

  public init(store: StoreOf<OtherProfileCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { (viewStore: ViewStoreOf<OtherProfileCore>) in
      VStack(spacing: 0) {
        if viewStore.isHeaderFolded {
          foldedHeaderView
            .debug()

        } else {
          unFoldedHeaderView

          Spacer().frame(height: 46)

          HStack {
            Text("업로드")
              .foregroundColor(.ds(.white))
              .font(.ds(.title2(.semibold)))

            Spacer()
          }
        }

        Spacer().frame(height: 16)

        SMScrollView(showIndicators: false, onOffsetChanged: viewStore.$scrollViewOffset) {
          LazyVGrid(columns: columns) {
            ForEach(viewStore.votes) { vote in
              ProfileCell(imageURL: vote.imageURL) {
                viewStore.send(.voteCellTapped(vote))
              }
              .onAppear {
                viewStore.send(._onScrollViewAppear(vote))
              }
            }
          }
        }
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
          if viewStore.member?.blocked != true {
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
              Image(icon: .ic_cancel)
                .renderingMode(.template)
                .foregroundColor(.ds(.white))
            }
          }
        }
      )
      .onAppear {
        viewStore.send(._onAppear)
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

        if let imageURL = viewStore.state?.imageURL,
           let url = URL(string: imageURL) {
          CacheAsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay {
                  Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                }

            default:
              defaultProfileImage(size: 80)
            }
          }
        } else {
          defaultProfileImage(size: 80)
        }

        Spacer().frame(height: 16)

        VStack(spacing: 6) {
          Text(viewStore.state?.nickName ?? "")
            .font(.ds(.title3(.semibold)))
            .foregroundColor(.ds(.black))

          Text(viewStore.state?.introduction ?? "")
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
      .frame(maxWidth: .infinity)
      .background(Color.ds(.green1))
      .cornerRadius(30)
    }
  }

  var foldedHeaderView: some View {
    WithViewStore(store, observe: { $0.member }) { viewStore in
      HStack(spacing: 0) {
        if let imageURL = viewStore.state?.imageURL,
           let url = URL(string: imageURL) {
          CacheAsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay {
                  Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                }

            default:
              defaultProfileImage(size: 60)
            }
          }
        } else {
          defaultProfileImage(size: 60)
        }

        Spacer().frame(width: 16)

        HStack {
          VStack(alignment: .leading, spacing: 8) {
            Text(viewStore.state?.nickName ?? "")
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
      OtherProfileView(store: .init(initialState: .init(memberID: 2), reducer: {
        OtherProfileCore()._printChanges()
      }))
    }
    .preferredColorScheme(.dark)
  }
}
