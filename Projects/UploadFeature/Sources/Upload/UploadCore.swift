import Foundation
import ComposableArchitecture

import Core

public struct UploadCore: Reducer {

  public struct State: Equatable {

    @PresentationState var textUploadState: TextUploadCore.State?

    public init() {}
  }

  public enum Action {
    case textUpload(PresentationAction<TextUploadCore.Action>)
    case textUploadButtonTapped
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .textUpload:
        return .none

      case .textUploadButtonTapped:
        state.textUploadState = .init()
        return .none
      }
    }
    .ifLet(\.$textUploadState, action: /Action.textUpload) {
      TextUploadCore()
    }
  }
}
