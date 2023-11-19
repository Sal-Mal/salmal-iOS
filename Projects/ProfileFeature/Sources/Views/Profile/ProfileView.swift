import SwiftUI
import ComposableArchitecture

import Core
import UI

public struct ProfileView: View {

  private let columns = [GridItem(.flexible()), GridItem(.flexible())]
  private let store: StoreOf<ProfileCore>
  
  public init(store: StoreOf<ProfileCore>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
      WithViewStore(store, observe: { $0 }) { viewStore in
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
              HStack(spacing: 12) {
                Button {
                  viewStore.send(.uploadTabButtonTapped)
                } label: {
                  Text("업로드")
                    .foregroundColor(viewStore.tab == .upload ? .ds(.white) : .ds(.gray3))
                    .font(.ds(.title2(.semibold)))
                }

                Button {
                  viewStore.send(.evaluationTabButtonTapped)
                } label: {
                  Text("투표")
                    .foregroundColor(viewStore.tab == .evaluation ? .ds(.white) : .ds(.gray3))
                    .font(.ds(.title2(.semibold)))
                }

                Spacer()

                Button {
                  viewStore.send(.voteEditButtonTapped)
                } label: {
                  Text("편집")
                    .foregroundColor(.ds(.white80))
                    .font(.ds(.title3(.medium)))
                }
              }
              .transition(.opacity)
            }

            VStack {
              Spacer().frame(height: 16)

              SMScrollView(showIndicators: false, onOffsetChanged: viewStore.$scrollViewOffset) {
                LazyVGrid(columns: columns) {
                  ForEach(viewStore.tab == .upload ? viewStore.votes : viewStore.evaluations) { vote in
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
        .smNavigationBar(title: "", rightItems: {
          HStack {
            NavigationLink(state: ProfileCore.Path.State.bookmarkList(.init())) {
              Image(icon: .bookmark)
            }
            NavigationLink(state: ProfileCore.Path.State.setting(.init())) {
              Image(icon: .setting)
            }
          }
        })
        .onAppear {
          viewStore.send(._onAppear)
		  NotificationService.post(.showTabBar)
        }
      }
    } destination: { state in
      switch state {
      case .otherProfile:
        CaseLet(/ProfileCore.Path.State.otherProfile, action: ProfileCore.Path.Action.otherProfile, then: OtherProfileView.init(store:))
      case .profileEdit:
        CaseLet(
          /ProfileCore.Path.State.profileEdit,
           action: ProfileCore.Path.Action.profileEdit,
           then: ProfileEditView.init(store:))
        
      case .blockedMemberList:
        CaseLet(
          /ProfileCore.Path.State.blockedMemberList,
           action: ProfileCore.Path.Action.blockedMemberList,
           then: BlockedMemberListView.init(store:))
        
      case .setting:
        CaseLet(
          /ProfileCore.Path.State.setting,
           action: ProfileCore.Path.Action.setting,
           then: SettingView.init(store:))
        
      case .bookmarkList:
        CaseLet(
          /ProfileCore.Path.State.bookmarkList,
           action: ProfileCore.Path.Action.bookmarkList,
           then: BookmarkListView.init(store:))
        
      case .uploadList:
        CaseLet(
          /ProfileCore.Path.State.uploadList,
           action: ProfileCore.Path.Action.uploadList,
           then: UploadListView.init(store:))
        
      case .salmalDetail:
        CaseLet(
          /ProfileCore.Path.State.salmalDetail,
           action: ProfileCore.Path.Action.salmalDetail,
           then: SalMalDetailView.init(store:)
        )
      
      case .web:
        CaseLet(
          /ProfileCore.Path.State.web,
           action: ProfileCore.Path.Action.web,
           then: WebView.init(store:)
        )
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

struct ProfileView_Previews: PreviewProvider {
  
  static var previews: some View {
    ProfileView(store: .init(initialState: .init(), reducer: {
      ProfileCore()._printChanges()
    }))
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
