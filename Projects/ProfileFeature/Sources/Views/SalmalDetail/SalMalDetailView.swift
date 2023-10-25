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
    VStack {
      RoundedRectangle(cornerRadius: 24).fill(Color.indigo)
        .overlay(alignment: .topLeading) {
          ProfileImage
            .padding([.top, .leading], 18)
        }
        .overlay(alignment: .bottomTrailing) {
          Buttons
            .padding(.trailing, 16)
            .padding(.bottom, 22)
        }
      
      VoteButtons
      
    }
      .smNavigationBar(
        title: "",
        leftItems: {
          Button {
            // 백버튼
          } label: {
            Image(icon: .chevron_left)
          }
        },
        rightItems: {
          Button {
            // 삭제
          } label: {
            Image(icon: .trash)
          }
        }
      )
  }
}

extension SalMalDetailView {
  var ProfileImage: some View {
    SMCapsuleButton(
      title: viewStore.vote.nickName,
      iconURL: URL(string: viewStore.vote.memberImageURL)!,
      foregroundColor: .ds(.white),
      backgroundColor: .ds(.black)
    ) {
      
    }
    .disabled(false)
  }
  
  var VoteButtons: some View {
    VStack(spacing: 9) {
      SMVoteButton(
        title: "👍🏻 살",
        progress: viewStore.buyPercentage,
        buttonState: viewStore.$salButtonState
      ) {

      }
      SMVoteButton(
        title: "👎🏻 말", progress:
          viewStore.notBuyPercentage,
        buttonState: viewStore.$malButtonState) {

        }
    }
  }
  
  var Buttons: some View {
    HStack(spacing: 12) {
      SMFloatingActionButton(
        iconImage: viewStore.vote.isBookmarked ? .init(icon: .bookmark_fill) : .init(icon: .bookmark),
        buttonSize: .medium,
        backgroundColor: .ds(.white36)) {
          store.send(.bookmarkTapped)
        }
        .debug()

      SMFloatingActionButton(
        iconImage: .init(icon: .messsage),
        buttonSize: .medium,
        badgeCount: viewStore.vote.commentCnt,
        backgroundColor: .ds(.white36)) {
          store.send(.commentTapped)
        }
        .debug()
    }
  }
}

struct SalMalDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SalMalDetailView(store: .init(initialState: .init(vote: VoteResponseDTO.mock.toDomain)) {
        SalMalDetailCore()
      })
    }
    .preferredColorScheme(.dark)
  }
}
