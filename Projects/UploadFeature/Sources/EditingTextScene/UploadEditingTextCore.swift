import Foundation
import ComposableArchitecture

import Core

public struct UploadEditingTextCore: Reducer {

  public struct State: Equatable {

    @BindingState var focusField: Field?

    public init() {}

    enum Field {
      case text
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case onAppear
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .onAppear:
        state.focusField = .text

        return .none
      }
    }
  }
}
