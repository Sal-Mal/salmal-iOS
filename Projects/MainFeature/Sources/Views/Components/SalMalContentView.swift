import SwiftUI
import UI

import ComposableArchitecture

public struct SalMalContentCore: Reducer {
  public struct State: Equatable {
    var vote: Vote
  }
  
  public enum Action: Equatable {
    case profileTapped
    case bookmarkTapped
    case commentTapped
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
        ZStack(alignment: .topLeading) {
          targetItem
            .frame(width: width, height: height)
          
          profile
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
        
      default:
        ZStack {
          ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
        }
      }
    }
  }
  
  private var profile: some View {
    SMCapsuleButton(
      title: viewStore.nickName,
      iconImage: .init(icon: .camera),
      buttonMode: .black
    ) {
      store.send(.profileTapped)
    }
    .padding([.top, .leading], 18)
  }
  
  private var bottomButtons: some View {
    HStack(spacing: 12) {
      SMFloatingActionButton(
        iconImage: .init(icon: .bookmark),
        buttonSize: .medium,
        badgeCount: viewStore.reviewCount,
        backgroundColor: .ds(.white36)) {
          store.send(.bookmarkTapped)
        }
      
      SMFloatingActionButton(
        iconImage: .init(icon: .messsage),
        buttonSize: .medium,
        badgeCount: viewStore.reviewCount,
        backgroundColor: .ds(.white36)) {
          store.send(.commentTapped)
        }
    }
  }
}

struct SalMalContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    SalMalContentView(store: .init(initialState: .init(vote: Vote.dummy)) {
      SalMalContentCore()
    })
    .padding(20)
  }
}
