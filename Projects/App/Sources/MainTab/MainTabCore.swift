import ComposableArchitecture

import UI

import MainFeature
import ProfileFeature
import UploadFeature

struct MainTabCore: Reducer {
  struct State: Equatable {
    @BindingState var tabIndex: TabItem = .home
    var showTab = true
        
    var salmalState = SalMalCore.State()
    var profileState = ProfileCore.State()
    
    @PresentationState var uploadState: UploadCore.State?
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case salmalAction(SalMalCore.Action)
    case profileAction(ProfileCore.Action)
    case uploadAction(PresentationAction<UploadCore.Action>)
    
    // MARK: - User Action
    case uploadButtonTapped
    
    // MARK: - internal Action
    case _setTabOpacity(Bool)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        break
      case .salmalAction, .profileAction, .uploadAction:
        break
        
      case .uploadButtonTapped:
        state.uploadState = .init()
        
      case let ._setTabOpacity(value):
        state.showTab = value
      }
      
      return .none
    }
    .ifLet(\.$uploadState, action: /Action.uploadAction) {
      UploadCore()
    }

    Scope(state: \.salmalState, action: /Action.salmalAction) {
      SalMalCore()
    }

    Scope(state: \.profileState, action: /Action.profileAction) {
      ProfileCore()
    }
  }
}
