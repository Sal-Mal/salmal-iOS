import SwiftUI
import UI
import Core
import ComposableArchitecture

public struct SalMalContentCore: Reducer {
  public struct State: Equatable {
    var vote: Vote
    @BindingState var isReportPresented = false
    @PresentationState var commentListState: CommentListCore.State?
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case commentList(PresentationAction<CommentListCore.Action>)
    case profileTapped
    case bookmarkTapped
    case commentTapped
    case moreTapped
  }
  
  @Dependency(\.network) var network

  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
//      case .commentList(.presented(<#T##Action#>))
        
      case .profileTapped:
        // TODO: Move To Profile
        return .none
        
      case .bookmarkTapped:
        // TODO: Book Mark
        return .none
        
      case .commentTapped:
        state.commentListState = .init(voteID: state.vote.id)
        return .none
        
      case .moreTapped:
        state.isReportPresented = true
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$commentListState, action: /Action.commentList) {
      CommentListCore()
    }
  }
}

public struct SalMalContentView: View {
  let store: StoreOf<SalMalContentCore>
  @ObservedObject var viewStore: ViewStoreOf<SalMalContentCore>
  
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
          targetItem
            .frame(width: width, height: height)
          
          TopBottons
            .padding([.horizontal, .top], 18)
        }
        
        bottomButtons
          .padding(.bottom, 22)
          .padding(.trailing, 16)
      }
      .bottomSheet(isPresented: viewStore.$isReportPresented) {
        let vote = viewStore.vote
        // TODO: Member ID
        ReportView(store: Store(initialState: .init(voteID: vote.id, memberID: vote.id)) {
          ReportCore()
        })
      }
      .sheet(store: store.scope(state: \.$commentListState, action: SalMalContentCore.Action.commentList)) { subStore in
        CommentListView(store: subStore)
          .presentationDetents([.medium, .large])
      }
      .debug()
    }
  }
}

extension SalMalContentView {
  
  private var targetItem: some View {
    AsyncImage(url: URL(string: viewStore.vote.imageURL)) { phase in
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
            .scaleEffect(2)
        }
      }
    }
  }
  
  var TopBottons: some View {
    HStack(alignment: .top) {
      SMCapsuleButton(
        title: viewStore.vote.nickName,
        iconImage: .init(icon: .camera),
        buttonMode: .black
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
    SalMalContentView(store: .init(initialState: .init(vote: VoteDTO.mock.toDomian)) {
      SalMalContentCore()
        ._printChanges()
    })
    .padding(20)
  }
}
