import UI
import Core

import ProfileFeature

import ComposableArchitecture

public struct SalMalCore: Reducer {
  public typealias ButtonState = SMVoteButton.ButtonState
  public typealias Tab = SMMainNavigationBar.Tab
  
  public struct State: Equatable {
    @BindingState var tab: Tab = .home
    
    @BindingState var buyPercentage: Double = 0
    @BindingState var notBuyPercentage: Double = 0
    var totalCount = 0
    var isAlarmExist = false
    
    var currentIndex: Int {
      if tab == .home {
        return homeState.index
      } else {
        return bestState.index
      }
    }
    
    var currentVote: Vote {
      if tab == .home {
        let index = homeState.index
        return homeState.votes[index].vote
      } else {
        let index = bestState.index
        return bestState.votes[index].vote
      }
    }
    
    @BindingState var salButtonState: ButtonState = .idle
    @BindingState var malButtonState: ButtonState = .idle
    
    var homeState = CarouselCore.State(tab: .home)
    var bestState = CarouselCore.State(tab: .best)
    var path = StackState<Path.State>()
    
    public init() {}
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case path(StackAction<Path.State, Path.Action>)
    case homeAction(CarouselCore.Action)
    case bestAction(CarouselCore.Action)
    
    case _requestAlarm
    case _setAlarmState(Bool)
    
    case moveToAlarm(AppState.AlarmModel? = nil) // 알람 화면으로 이동
    case buyTapped // 살 버튼 눌렀을때
    case notBuyTapped // 말 버튼 눌렀을때
    case requestVote(id: Int) // id에 해당하는 Vote 데이터 요청
    case updateVote(Vote) // ChildCore의 voteList 배열 업데이트
    case updateUI(Vote) // 현재화면 업데이트
  }
  
  public init() { }
  
  @Dependency(\.voteRepository) var voteRepository
  @Dependency(\.notificationRepository) var notiRepository
  @Dependency(\.toastManager) var toastManager
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding: break
        
      case let .path(.element(_, action: .otherProfileScreen(.delegate(.moveToSalMalDetail(vote))))):
        state.path.append(.salmalDetailScreen(.init(vote: vote)))
      
      case let .path(.element(_, action: .salmalDetailScreen(.delegate(.moveToOtherProfile(id))))):
        state.path.append(.otherProfileScreen(.init(memberID: id)))
        
      case let .path(.element(_, action: .alarmScreen(.delegate(.pushTarget(vote, model))))):
        state.path.append(.salmalDetailScreen(.init(vote: vote, model: model)))
        
      case .path: break
        
        // homeTab의 index가 바뀔때마다 실행
      case let .homeAction(.delegate(.updateVote(vote))):
        return .send(.updateVote(vote))
        
      case let .homeAction(.delegate(.moveToprofile(id))):
        state.path.append(.otherProfileScreen(.init(memberID: id)))
        
      case .homeAction: break
        
        // bestTab의 index가 바뀔때마다 실행
      case let .bestAction(.delegate(.updateVote(vote))):
        return .send(.updateVote(vote))
        
      case let .bestAction(.delegate(.moveToprofile(id))):
        state.path.append(.otherProfileScreen(.init(memberID: id)))
        
      case .bestAction: break
        
      case ._requestAlarm:
        return .run { send in
          let isAlarmExist = try await !notiRepository.requestAlarmList().isEmpty
          await send(._setAlarmState(isAlarmExist))
        }
        
      case let ._setAlarmState(value):
        state.isAlarmExist = value
        
      case let .moveToAlarm(model):
        state.path.append(.alarmScreen(.init(model: model)))
      
      case .buyTapped:
        if state.homeState.votes.isEmpty && state.tab == .home {
          return .none // 비어있을 경우 아무동작하지 않음
        }
        
        if state.bestState.votes.isEmpty && state.tab == .best {
          return .none // // 비어있을 경우 아무동작하지 않음
        }
        
        return .run { [state] send in
          switch state.salButtonState {
            // 투표
          case .idle:
            try await voteRepository.evaluate(voteID: state.currentVote.id, param: .init(voteEvaluationType: .like))
            await send(.requestVote(id: state.currentVote.id))
            
            // 투표 취소
          case .selected:
            try await voteRepository.unEvaluate(voteID: state.currentVote.id)
            await send(.requestVote(id: state.currentVote.id))
            // 투표 불가
          case .unSelected:
            await toastManager.showToast(.error("이미 반대편에 투표했어요"))
          }
        } catch: { error, send in
          print(error.localizedDescription)
        }
        
      case .notBuyTapped:
        if state.homeState.votes.isEmpty && state.tab == .home {
          return .none // 비어있을 경우 아무동작하지 않음
        }
        
        if state.bestState.votes.isEmpty && state.tab == .best {
          return .none // // 비어있을 경우 아무동작하지 않음
        }
        
        return .run { [state] send in
          switch state.malButtonState {
            // 투표
          case .idle:
            try await voteRepository.evaluate(voteID: state.currentVote.id, param: .init(voteEvaluationType: .dislike))
            await send(.requestVote(id: state.currentVote.id))
            // 투표 취소
          case .selected:
            try await voteRepository.unEvaluate(voteID: state.currentVote.id)
            await send(.requestVote(id: state.currentVote.id))
            // 투표 불가
          case .unSelected:
            await toastManager.showToast(.error("이미 반대편에 투표했어요"))
          }
        } catch: { error, send in
          print(error.localizedDescription)
        }
        
      case let .requestVote(id):
        return .run { send in
          let vote = try await voteRepository.getVote(id: id)
          await send(.updateVote(vote))
        }
        
      case let .updateVote(vote):
        
        if state.tab == .home {
          state.homeState.votes[state.currentIndex] = .init(vote: vote)
        } else {
          state.bestState.votes[state.currentIndex] = .init(vote: vote)
        }
        
        return .send(.updateUI(vote))
        
      case let .updateUI(vote):
        state.totalCount = vote.totalVoteCount
        
        if vote.totalVoteCount == 0 {
          state.buyPercentage = 0
          state.notBuyPercentage = 0
        } else {
          state.buyPercentage = Double(vote.likeCount) / Double(vote.totalVoteCount)
          state.notBuyPercentage = Double(vote.disLikeCount) / Double(vote.totalVoteCount)
        }
        
        switch vote.voteStatus {
        case .like:
          state.salButtonState = .selected
          state.malButtonState = .unSelected
          
        case .disLike:
          state.salButtonState = .unSelected
          state.malButtonState = .selected
          
        case .none:
          state.salButtonState = .idle
          state.malButtonState = .idle
        }
      }
      
      return .none
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
    
    Scope(state: \.homeState, action: /Action.homeAction) {
      CarouselCore()
    }
    
    Scope(state: \.bestState, action: /Action.bestAction) {
      CarouselCore()
    }
  }
}

public extension SalMalCore {
  struct Path: Reducer {
    public enum State: Equatable {
      case alarmScreen(AlarmCore.State)
      case otherProfileScreen(OtherProfileCore.State)
      case salmalDetailScreen(SalMalDetailCore.State)
    }
    
    public enum Action: Equatable {
      case alarmScreen(AlarmCore.Action)
      case otherProfileScreen(OtherProfileCore.Action)
      case salmalDetailScreen(SalMalDetailCore.Action)
    }
    
    public var body: some ReducerOf<Self> {
      Scope(state: /State.alarmScreen, action: /Action.alarmScreen) {
        AlarmCore()
      }
      
      Scope(state: /State.otherProfileScreen, action: /Action.otherProfileScreen) {
        OtherProfileCore()
      }
      
      Scope(state: /State.salmalDetailScreen, action: /Action.salmalDetailScreen) {
        SalMalDetailCore()
      }
    }
  }
}
