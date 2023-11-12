import SwiftUI

import ProfileFeature

import Core
import UI
import ComposableArchitecture

public struct VoteItemView: View {
  let store: StoreOf<VoteItemCore>
  @ObservedObject var viewStore: ViewStoreOf<VoteItemCore>
  
  @State var modalHeight: CGFloat = .zero
  
  public init(store: StoreOf<VoteItemCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let width = proxy.size.width
      let height = proxy.size.height
      
      ZStack(alignment: .top) {
        ZStack(alignment: .bottomTrailing) {
          targetItem
            .frame(width: width, height: height)
          
          bottomButtons
            .padding(.bottom, 22)
            .padding(.trailing, 16)
        }
        
        TopBottons
          .padding([.horizontal, .top], 18)
      }
      .sheet(store: store.scope(state: \.$reportState, action: VoteItemCore.Action.report)) { subStore in
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
      .sheet(store: store.scope(state: \.$commentListState, action: VoteItemCore.Action.commentList)) { subStore in
        VStack(spacing: 0) {
          DragIndicator()
            .padding(.bottom, -20)
          CommentListView(store: subStore)
        }
        .presentationDragIndicator(.hidden)
        .background(Color.ds(.gray4))
      }
    }
  }
}

extension VoteItemView {
  
  private var targetItem: some View {
    CacheAsyncImage(url: URL(string: viewStore.vote.imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!) { phase in
      switch phase {
      case let .success(image):
        image
          .fill()
          .clipShape(Rectangle())
        
      case .failure:
        // TODO: Error 처리
        Text("Error")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .contentShape(Rectangle())
        
      default:
        ProgressView()
          .progressViewStyle(.circular)
          .tint(.ds(.green1))
          .scaleEffect(2)
      }
    }
  }
  
  var TopBottons: some View {
    HStack(alignment: .top) {
      SMCapsuleButton(
        title: viewStore.vote.nickName,
        iconURL: URL(string: viewStore.vote.memberImageURL)!,
        foregroundColor: .ds(.white),
        backgroundColor: .ds(.black)
      ) {
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
  
  private var bottomButtons: some View {
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

struct VoteItemView_Previews: PreviewProvider {
  
  static var previews: some View {
    VoteItemView(store: .init(initialState: .init(vote: VoteResponseDTO.mock.toDomain)) {
      VoteItemCore()
    })
    .padding(20)
  }
}
