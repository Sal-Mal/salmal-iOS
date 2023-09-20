import SwiftUI

import Core
import UI
import ComposableArchitecture

public struct SalMalContentView: View {
  let store: StoreOf<SalMalContentCore>
  @ObservedObject var viewStore: ViewStoreOf<SalMalContentCore>
  
  @State var modalHeight: CGFloat = .zero
  
  public init(store: StoreOf<SalMalContentCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let width = proxy.size.width
      let height = proxy.size.height
      
      ZStack(alignment: .bottomTrailing) {
        ZStack(alignment: .top) {
          ZStack {
            targetItem
              .frame(width: width, height: height)
              .onAppear {
                print("\(viewStore.vote.id) \(viewStore.vote.imageURL)")
              }
            
            Text("\(viewStore.vote.id)")
              .foregroundColor(.black)
              .bold()
              .font(.largeTitle)
          }
          
          TopBottons
            .padding([.horizontal, .top], 18)
        }
        
        bottomButtons
          .padding(.bottom, 22)
          .padding(.trailing, 16)
      }
      .sheet(store: store.scope(state: \.$reportState, action: SalMalContentCore.Action.report)) { subStore in
        ReportView(store: subStore)
          .readHeight()
          .onPreferenceChange(HeightPreferenceKey.self) { height in
            if let height {
              self.modalHeight = height
            }
          }
          .presentationDetents([.height(self.modalHeight)])
          .presentationDragIndicator(.visible)
          
      }
      .sheet(store: store.scope(state: \.$commentListState, action: SalMalContentCore.Action.commentList)) { subStore in
        CommentListView(store: subStore)
          .presentationDetents([.fraction(0.7), .large])
          .presentationDragIndicator(.visible)
      }
    }
  }
}

extension SalMalContentView {
  
  private var targetItem: some View {
    return AsyncImage(url: URL(string: viewStore.vote.imageURL)) { phase in
      switch phase {
      case let .success(image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .clipShape(Rectangle())
        
      case .failure:
        // TODO: Error 처리
        Text("Error")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .contentShape(Rectangle())
        
      default:
        ZStack {
          ProgressView()
            .progressViewStyle(.circular)
            .tint(.ds(.green1))
            .scaleEffect(2)
        }
      }
    }
  }
  
  var TopBottons: some View {
    HStack(alignment: .top) {
      SMCapsuleButton(
        title: viewStore.vote.nickName,
        iconURL: URL(string: viewStore.vote.memberImageURL)!) {
          store.send(.profileTapped)
        }
      
      Spacer()
      
      Button {
        store.send(.moreTapped)
      } label: {
        Image(icon: .ic_more)
          .fit(size: 24)
      }
    }
  }
  
  private var bottomButtons: some View {
    HStack(spacing: 12) {
      SMFloatingActionButton(
        iconImage: viewStore.vote.isBookmarked ? .init(icon: .bookmark_fill) : .init(icon: .bookmark),
        buttonSize: .medium,
        badgeCount: viewStore.vote.bookmarkCount,
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

struct SalMalContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    SalMalContentView(store: .init(initialState: .init(vote: VoteDTO.mock.toDomain)) {
      SalMalContentCore()
        ._printChanges()
    })
    .padding(20)
  }
}
