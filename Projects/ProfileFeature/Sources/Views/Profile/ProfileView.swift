import SwiftUI
import ComposableArchitecture

import Core
import UI

public struct ProfileView: View {
  
  private let store: StoreOf<ProfileCore>
  
  @State private var scrollOffsetY: CGFloat = 0
  @State private var viewHeight: CGFloat = 0
  
  public init(store: StoreOf<ProfileCore>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
      WithViewStore(store, observe: { $0 }) { viewStore in
        VStack {
          if scrollOffsetY >= 0 {
            VStack {
              AsyncImage(url: URL(string: viewStore.member?.imageURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay {
                      Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                    }

                default:
                  Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .background(.gray)
                    .clipShape(Circle())
                    .overlay {
                      Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                    }
                }
              }
              Text(viewStore.member?.nickName ?? "")
                .font(.ds(.title3(.semibold)))
                .foregroundColor(.ds(.black))
              Text(viewStore.member?.introduction ?? "")
                .font(.ds(.title4(.medium)))
                .foregroundColor(.ds(.black))

              HStack(spacing: 62) {
                HStack {
                  Text("👍🏻살")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundColor(.ds(.green1))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(Color.ds(.black))
                    .clipShape(Capsule())

                  Text("\(viewStore.member?.likeCount ?? 0)")
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

                  Text("\(viewStore.member?.disLikeCount ?? 0)")
                    .font(.ds(.title2(.semibold)))
                    .foregroundColor(.ds(.black))
                }
              }
            }
            .frame(height: viewHeight)
            .frame(maxWidth: .infinity)
            .background(Color.ds(.green1))
            .cornerRadius(30)
          } else {
            HStack {
              AsyncImage(url: URL(string: viewStore.member?.imageURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay {
                      Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                    }

                default:
                  Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .background(.gray)
                    .clipShape(Circle())
                    .overlay {
                      Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                    }
                }
              }
              VStack(alignment: .leading) {
                Text(viewStore.member?.nickName ?? "")
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

                    Text("\(viewStore.member?.likeCount ?? 0)")
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

                    Text("\(viewStore.member?.disLikeCount ?? 0)")
                      .font(.ds(.title2(.semibold)))
                      .foregroundColor(.ds(.black))
                  }
                }
              }
              Spacer()
            }
            .padding()
            .frame(height: viewHeight)
            .frame(maxWidth: .infinity)
            .background(Color.ds(.green1))
            .cornerRadius(30)
          }

          Spacer(minLength: 32)

          if viewHeight != 100 {
            HStack {
              Button {
                viewStore.send(.setTab(.uploads))
              } label: {
                Text("업로드")
                  .foregroundColor(viewStore.tab == .uploads ? .ds(.white) : .ds(.white36))
                  .font(.ds(.title2(.semibold)))
              }

              Button {
                viewStore.send(.setTab(.votes))
              } label: {
                Text("투표")
                  .foregroundColor(viewStore.tab == .votes ? .ds(.white) : .ds(.white36))
                  .font(.ds(.title2(.semibold)))
              }

              Spacer()

              NavigationLink(
                state: ProfileCore.Path.State.uploadList()
              ) {
                Text("편집")
                  .foregroundColor(.ds(.white80))
                  .font(.ds(.title3(.medium)))
              }
            }
          }

          SMScrollView { offset in
            scrollOffsetY = offset.y
            print(offset.y)
          } content: {
            LazyVGrid(columns: [.init(), .init()]) {
              ForEach(viewStore.tab == .uploads ? viewStore.votes : viewStore.evaluations, id: \.id) { vote in
                GeometryReader { proxy in
                  AsyncImage(url: URL(string: vote.imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                      image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(24.0)

                    default:
                      RoundedRectangle(cornerRadius: 24.0)
                        .fill(.gray)
                    }
                  }
                  .frame(height: proxy.size.width)
                }
                .clipped()
                .cornerRadius(24.0)
                .aspectRatio(1, contentMode: .fit)
              }
            }
          }
          .scrollIndicators(.hidden)
        }
        .padding()
        .smNavigationBar(title: "", leftItems: {}, rightItems: {
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
          scrollOffsetY = 0
          viewHeight = 200
        }
        .onChange(of: scrollOffsetY) { newValue in
          withAnimation(.linear(duration: 0.2)) {
            if newValue >= 0 {
              viewHeight = 200
            } else {
              viewHeight = 100
            }
          }
        }
      }
    } destination: { state in
      switch state {
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
      }
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
