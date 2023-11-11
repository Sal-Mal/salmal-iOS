import SwiftUI

import Core
import UI
import ComposableArchitecture

public struct SalMalDetailView: View {
  let store: StoreOf<SalMalDetailCore>
  @ObservedObject var viewStore: ViewStoreOf<SalMalDetailCore>
  @State var modalHeight: CGFloat = .zero
  
  public init(store: StoreOf<SalMalDetailCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 25) {
      VoteImage
        .overlay(alignment: .topLeading) {
          ProfileImage
            .padding([.horizontal, .top], 18)
        }
        .overlay(alignment: .bottomTrailing) {
          FloatingButtons
            .padding(.trailing, 16)
            .padding(.bottom, 22)
        }
        .overlay(alignment: .bottom) {
          NumberOfVotesView(number: viewStore.vote.totalVoteCount)
            .offset(y: 12)
        }
        .padding(.horizontal, 16)
      
      VoteButtons
        .padding(.horizontal, 18)
    }
    .onAppear {
      store.send(.requestVote(id: viewStore.vote.id))
      NotificationService.post(.hideTabBar)
    }
    .padding(.vertical, 18)
    .sheet(
      store: store.scope(state: \.$commentListState, action: SalMalDetailCore.Action.commentList)) { subStore in
        VStack(spacing: 0) {
          DragIndicator()
            .padding(.bottom, -20)
          CommentListView(store: subStore)
        }
        .presentationDetents([.large, .medium])
        .presentationDragIndicator(.hidden)
        .background(Color.ds(.gray4))
      }
      .sheet(
        store: store.scope(state: \.$reportState, action: SalMalDetailCore.Action.report)) { subStore in
          ReportView(store: subStore)
            .readHeight()
            .onPreferenceChange(HeightPreferenceKey.self) { height in
              if let height {
                self.modalHeight = height
              }
            }
            .presentationDetents([.height(self.modalHeight)])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.ds(.gray4))
        }
        .smNavigationBar(
          title: "",
          leftItems: {
            Button {
              store.send(.backButtonTapped)
            } label: {
              Image(icon: .chevron_left)
            }
          },
          rightItems: {
            if viewStore.isMine {
              Button {
                store.send(.deleteVoteTapped)
              } label: {
                Image(icon: .ic_trash)
              }
            } else {
              EmptyView()
            }
          }
        )
  }
}

extension SalMalDetailView {
  var VoteImage: some View {
    CacheAsyncImage(url: URL(string: viewStore.vote.imageURL)!) { phase in
      switch phase {
      case .success(let image):
        image
          .fill()
          .frame(width: UIScreen.main.bounds.width - 36)
          .clipped()
          .cornerRadius(24)
      default:
        Rectangle()
      }
    }
  }
  
  var ProfileImage: some View {
    
    HStack(alignment: .top) {
      SMCapsuleButton(
        title: viewStore.vote.nickName,
        iconURL: URL(string: viewStore.vote.memberImageURL)!,
        foregroundColor: .ds(.white),
        backgroundColor: .ds(.black)
      ) {
        // TODO: 프로필 화면으로 이동
        store.send(.profileTapped)
      }
      
      Spacer()
      
      Button {
        store.send(.moreTapped)
      } label: {
        Image(icon: .ic_more)
          .fit(size: 24)
      }
      .opacity(viewStore.isMine ? 0 : 1)
    }
  }
  
  var VoteButtons: some View {
    VStack(spacing: 9) {
      SMVoteButton(
        title: "👍🏻 살",
        progress: viewStore.$buyPercentage,
        buttonState: viewStore.$salButtonState
      ) {
        store.send(.salButtonTapped)
      }
      
      SMVoteButton(
        title: "👎🏻 말", progress:
          viewStore.$notBuyPercentage,
        buttonState: viewStore.$malButtonState
      ) {
        store.send(.malButtonTapped)
      }
    }
  }
  
  var FloatingButtons: some View {
    HStack(spacing: 12) {
      SMFloatingActionButton(
        iconImage: viewStore.vote.isBookmarked ? .init(icon: .bookmark_fill) : .init(icon: .bookmark),
        buttonSize: .medium,
        backgroundColor: .ds(.white36)) {
          store.send(.bookmarkTapped)
        }
      
      SMFloatingActionButton(
        iconImage: .init(icon: .ic_message),
        buttonSize: .medium,
        badgeCount: viewStore.vote.commentCnt,
        backgroundColor: .ds(.white36)) {
          store.send(.commentTapped)
        }
    }
  }
}

struct SalMalDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SalMalDetailView(store: .init(initialState: .init(vote: VoteResponseDTO.mock.toDomain)) {
        SalMalDetailCore()
          ._printChanges()
      })
    }
    .preferredColorScheme(.dark)
  }
}
