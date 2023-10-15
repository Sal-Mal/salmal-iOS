import SwiftUI
import PhotosUI
import AVFoundation
import ComposableArchitecture

import Core

public struct ProfileEditCore: Reducer {

  public struct State: Equatable {
    @BindingState var nickName: String = ""
    @BindingState var introduction: String = ""
    @BindingState var isPhotoSheetPresented: Bool = false
    @BindingState var isPhotoLibraryPresented: Bool = false
    @BindingState var isTakePhotoPresented: Bool = false
    @BindingState var isWithdrawalPresented: Bool = false
    @BindingState var selectedItem: PhotosPickerItem?

    var member: Member?
    var imageData: Data?

    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case onAppear
    case dismissButtonTapped
    case confirmButtonTapped
    case selectInPhotoLibraryButtonTapped
    case takePhotoButtonTapped
    case cancelTakePhotoButtonTapped
    case removeCurrentPhotoButtonTapped
    case logoutButtonTapped
    case withdrawalButtonTapped
    case setMember(Member)
    case setImage(Data?)
    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.memberRepository) var memberRepository: MemberRepository

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let member = try await memberRepository.myPage()
          await send(.setMember(member))
        }

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }

      case .confirmButtonTapped:
        return .run { [state] send in
          try await memberRepository.update(nickname: state.nickName, introduction: state.introduction)

          if let data = state.imageData {
            try await memberRepository.updateImage(data: data)
          }
          await dismiss()

        } catch: { error, send in
          print(error)
        }

      case .selectInPhotoLibraryButtonTapped:
        state.isPhotoLibraryPresented = true
        state.isPhotoSheetPresented = false
        return .none

      case .takePhotoButtonTapped:
        state.isPhotoSheetPresented = false
        state.isTakePhotoPresented = true
        return .none

      case .removeCurrentPhotoButtonTapped:
        state.isPhotoSheetPresented = false
        state.imageData = nil
        return .none

      case .cancelTakePhotoButtonTapped:
        state.isTakePhotoPresented = false
        return .none

      case .binding(\.$selectedItem):
        guard let item = state.selectedItem else { return .none }

        return .run { send in
          let data = try await item.loadTransferable(type: Data.self)
          await send(.setImage(data))
        }

      case .binding:
        return .none

      case .logoutButtonTapped:
        return .run { send in
          // TODO: 로그아웃 처리
        }

      case .withdrawalButtonTapped:
        return .run { send in
          try await memberRepository.delete()

        } catch: { error, send in
          print(error)
        }

      case .setMember(let member):
        state.member = member
        state.nickName = member.nickName
        state.introduction = member.introduction
        return .none

      case .setImage(let data):
        state.imageData = data
        return .none
      }
    }
  }
}
