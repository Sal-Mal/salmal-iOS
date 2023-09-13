//
//  CommentListView.swift
//  MainFeature
//
//  Created by LS-MAC-00213 on 2023/09/13.
//

import SwiftUI
import ComposableArchitecture

public struct CommentListCore: Reducer {
  public struct State: Equatable {
    let voteID: Int
  }
  
  public enum Action: Equatable {
    
  }
  
  @Dependency(\.network) var network
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}

public struct CommentListView: View {
  let store: StoreOf<CommentListCore>
  @ObservedObject var viewStore: ViewStoreOf<CommentListCore>
  
  public init(store: StoreOf<CommentListCore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    Text("")
  }
}

struct CommentListView_Previews: PreviewProvider {
  static var previews: some View {
    CommentListView(store: .init(initialState: CommentListCore.State(voteID: 0)) {
      CommentListCore()
    })
  }
}
