import SwiftUI

import UI
import Core
import ComposableArchitecture

// TODO: Toast Message

public struct ReportCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
    let memberID: Int
    let items: [MenuItem] = [
      .init(icon: .init(icon: .warning), title: "해당 게시물 신고하기"),
      .init(icon: .init(icon: .cancel), title: "이 사용자 차단하기")
    ]
  }
  
  public enum Action: Equatable {
    case tap(index: Int)
  }
  
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let .tap(index):
        switch index {
        case 0:
          return .run { [id = state.voteID] send in
            try await network.request(VoteAPI.report(id: id))
            NotiManager.post(.reportVote, userInfo: ["id": id])
            // TODO:  토스트 메시지 띄우기
          } catch: { error, send in
            // TODO: 에러처리 (토스트)
          }
        case 1:
          return .run { [id = state.memberID] send in
            try await network.request(MemberAPI.ban(id: id))
            NotiManager.post(.banUser, userInfo: ["id": id])
            // TODO:  토스트 메시지 띄우기
          } catch: { error, send in
            // TODO: 에러처리 (토스트)
          }
          
        default:
          return .none
        }
      }
    }
  }
}

public struct ReportView: View {
  @Environment(\.dismiss) var dismiss
  
  let store: StoreOf<ReportCore>
  @ObservedObject var viewStore: ViewStoreOf<ReportCore>
  
  public init(store: StoreOf<ReportCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      ForEach(viewStore.items.indices, id: \.self) { index in
        MenuRow(item: viewStore.items[index])
          .onTapGesture {
            store.send(.tap(index: index))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              dismiss()
            }
          }
      }
    }
    .padding(.top, 43)
  }
}

struct ReportView_Previews: PreviewProvider {
  static var previews: some View {
    ReportView(store: .init(initialState: ReportCore.State(voteID: .zero, memberID: .zero)) {
      ReportCore()
    })
  }
}

