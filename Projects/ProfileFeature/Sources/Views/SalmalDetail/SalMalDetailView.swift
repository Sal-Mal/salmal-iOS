import SwiftUI

import Core
import UI
import ComposableArchitecture

struct SalMalDetailView: View {
  let store: StoreOf<SalMalDetailCore>
  @ObservedObject var viewStore: ViewStoreOf<SalMalDetailCore>
  
  init(store: StoreOf<SalMalDetailCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }
  
  var body: some View {
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
    .sheet(
      store: store.scope(state: \.$commentListState, action: SalMalDetailCore.Action.commentList)) { subStore in
        CommentListView(store: subStore)
      }
      .sheet(
        store: store.scope(state: \.$reportState, action: SalMalDetailCore.Action.report)) { subStore in
          ReportView(store: subStore)
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
            Button {
              store.send(.deleteVoteTapped)
            } label: {
              Image(icon: .trash)
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
          .resizable()
      default:
        Rectangle()
      }
    }
    .cornerRadius(24)
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
        progress: viewStore.buyPercentage,
        buttonState: viewStore.$salButtonState
      ) {
        //empty
      }
      
      SMVoteButton(
        title: "👎🏻 말", progress:
          viewStore.notBuyPercentage,
        buttonState: viewStore.$malButtonState
      ) {
        // empty
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
        iconImage: .init(icon: .messsage),
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
