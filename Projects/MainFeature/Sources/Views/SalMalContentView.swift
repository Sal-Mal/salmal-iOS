import SwiftUI
import UI
import Core
import ComposableArchitecture

public struct SalMalContentCore: Reducer {
  public struct State: Equatable {
    var vote: Vote
  }
  
  public enum Action: Equatable {
    case profileTapped
    case bookmarkTapped
    case commentTapped
    case moreTapped
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .profileTapped:
        return .none
      case .bookmarkTapped:
        return .none
      case .commentTapped:
        return .none
      case .moreTapped:
        return .none
      }
    }
  }
}

public struct SalMalContentView: View {
  let store: StoreOf<SalMalContentCore>
  @ObservedObject var viewStore: ViewStore<Vote, SalMalContentCore.Action>
  
  public init(store: StoreOf<SalMalContentCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: \.vote)
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
    }
  }
}

extension SalMalContentView {
  
  private var targetItem: some View {
    AsyncImage(url: URL(string: viewStore.imageURL)) { phase in
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
        title: viewStore.nickName,
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
        iconImage: viewStore.isBookmarked ? .init(icon: .bookmark_fill) : .init(icon: .bookmark),
        buttonSize: .medium,
        badgeCount: viewStore.bookmarkCount,
        backgroundColor: .ds(.white36)) {
          store.send(.bookmarkTapped)
        }
      
      SMFloatingActionButton(
        iconImage: .init(icon: .messsage),
        buttonSize: .medium,
        badgeCount: viewStore.commentCnt,
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
    })
    .padding(20)
  }
}
