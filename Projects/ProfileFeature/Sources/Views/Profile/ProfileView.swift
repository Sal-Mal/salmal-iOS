import SwiftUI
import ComposableArchitecture

import Core
import UI

public struct ProfileView: View {
  
  @State private var scrollOffsetY: CGFloat = 0
  
  private let store: StoreOf<ProfileCore>
  
  public init(store: StoreOf<ProfileCore>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
      WithViewStore(store, observe: { $0 }) { viewStore in
        VStack {
          VStack(spacing: scrollOffsetY >= 0 ? 32 : 16) {
            if scrollOffsetY >= 0 {
              UnFoldedHeaderView(member: viewStore.member)
            } else {
              FoldedHeaderView(member: viewStore.member)
            }
            
            VStack {
              if scrollOffsetY >= 0 {
                HStack {
                  HStack(spacing: 12) {
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
              } content: {
                LazyVGrid(columns: [.init(), .init()]) {
                  ForEach(viewStore.tab == .uploads ? viewStore.votes : viewStore.evaluations, id: \.id) { vote in
                    if let imageURL = URL(string: vote.imageURL) {
                      CacheAsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                          image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .cornerRadius(24)
                            .onTapGesture {
                              store.send(.requestVote(vote.id))
                            }
                          
                        default:
                          RoundedRectangle(cornerRadius: 24)
                            .fill(Color.ds(.gray2))
                            .aspectRatio(1, contentMode: .fill)
                        }
                      }
                      
                    } else {
                      RoundedRectangle(cornerRadius: 24)
                        .fill(Color.ds(.gray2))
                        .aspectRatio(1, contentMode: .fill)
                    }
                  }
                }
              }
            }
          }
          .padding(18)
        }
        .onAppear {
          viewStore.send(.onAppear)
          NotificationService.post(.showTabBar)
        }
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
      }
    }
  }
  
  func FoldedHeaderView(member: Member?) -> some View {
    HStack(spacing: 16) {
      if let imageURL = URL(string: member?.imageURL ?? "") {
        CacheAsyncImage(url: imageURL) { phase in
          switch phase {
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
              .frame(width: 70, height: 70)
              .clipShape(Circle())
              .overlay {
                Circle()
                  .stroke(lineWidth: 1)
                  .foregroundColor(.ds(.white))
              }
            
          default:
            DefaultImage()
          }
        }
        
      } else {
        DefaultImage()
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text(member?.nickName ?? "닉네임")
          .font(.ds(.title3(.semibold)))
          .foregroundColor(.ds(.black))
        
        HStack(spacing: 16) {
          HStack(spacing: 6) {
            Text("👍🏻")
              .font(.pretendard(.semiBold, size: 12))
              .padding(6)
              .background(Color.ds(.black))
              .clipShape(Circle())
            
            Text("\(member?.likeCount ?? 0)")
              .font(.ds(.title2(.semibold)))
              .foregroundColor(.ds(.black))
          }
          
          HStack(spacing: 6) {
            Text("👎🏻")
              .font(.pretendard(.semiBold, size: 12))
              .padding(6)
              .background(Color.ds(.black))
              .clipShape(Circle())
            
            Text("\(member?.disLikeCount ?? 0)")
              .font(.ds(.title2(.semibold)))
              .foregroundColor(.ds(.black))
          }
        }
      }
      Spacer()
    }
    .padding(.vertical, 18)
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity)
    .background(Color.ds(.green1))
    .cornerRadius(30)
  }
  
  func UnFoldedHeaderView(member: Member?) -> some View {
    VStack(spacing: 30) {
      VStack(spacing: 16) {
        if let imageURL = URL(string: member?.imageURL ?? "") {
          CacheAsyncImage(url: imageURL) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay {
                  Circle()
                    .stroke(lineWidth: 1)
                    .foregroundColor(.ds(.white))
                }
              
            default:
              DefaultImage()
            }
          }
          
        } else {
          DefaultImage()
        }
        
        VStack(spacing: 6) {
          Text(member?.nickName ?? "닉네임")
            .font(.ds(.title3(.semibold)))
            .foregroundColor(.ds(.black))
          
          Text(member?.introduction ?? "자기 소개")
            .font(.ds(.title4(.medium)))
            .foregroundColor(.ds(.black))
        }
      }
      
      HStack(spacing: 62) {
        HStack(spacing: 6) {
          Text("👍🏻살")
            .font(.pretendard(.semiBold, size: 14))
            .foregroundColor(.ds(.green1))
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .background(Color.ds(.black))
            .clipShape(Capsule())
          
          Text("\(member?.likeCount ?? 0)")
            .font(.ds(.title2(.semibold)))
            .foregroundColor(.ds(.black))
        }
        HStack(spacing: 6) {
          Text("👎🏻말")
            .font(.pretendard(.semiBold, size: 14))
            .foregroundColor(.ds(.green1))
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .background(Color.ds(.black))
            .clipShape(Capsule())
          
          Text("\(member?.disLikeCount ?? 0)")
            .font(.ds(.title2(.semibold)))
            .foregroundColor(.ds(.black))
        }
      }
    }
    .padding(.vertical, 30)
    .frame(maxWidth: .infinity)
    .background(Color.ds(.green1))
    .cornerRadius(30)
  }
  
  func DefaultImage() -> some View {
    Image(icon: .person_fill)
      .resizable()
      .frame(width: 30, height: 30)
      .scaledToFit()
      .frame(width: 70, height: 70)
      .background(Color.ds(.gray2))
      .clipShape(Circle())
      .overlay {
        Circle()
          .stroke(lineWidth: 1)
          .foregroundColor(.white)
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
