import Foundation
import SwiftUI
import ComposableArchitecture

import Core
import UI

public struct UploadEditingTextCore: Reducer {

  public struct State: Equatable {
    @BindingState var text: String = ""
    @BindingState var focusField: Field?

    @BindingState var font: Font? = .ds(.title2(.medium))
    @BindingState var foregroundColor: Color? = .ds(.white)
    @BindingState var backgroundColor: Color? = .clear

    public init() {}

    public enum Field { case text }
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
      case .binding(\.$text):
        state.text = String(state.text.prefix(100))
        return .none

      case .binding:
        return .none

      case .onAppear:
        state.focusField = .text
        return .none
      }
    }
  }
}
