import Foundation
import ComposableArchitecture

import Core

public struct ProfileEditCore: Reducer {

  public struct State: Equatable {
    @BindingState var nickName: String = ""
    @BindingState var introduction: String = ""
    @BindingState var imageURL: String = ""
    @BindingState var isPhotoPresented: Bool = false
    @BindingState var isDeactivatePresented: Bool = false

    var member: Member?

    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case onAppear
    case dismissButtonTapped
    case confirmButtonTapped
    // 프로필 사진 설정
    case selectInPhotoLibraryButtonTapped
    case takePhotoButtonTapped
    case deleteCurrentPhotoButtonTapped
    // 프로필 닉네임, 자기소개 설정
    case binding(BindingAction<State>)
    // 로그아웃, 서비스탈퇴
    case logoutButtonTapped
    case deactivateButtonTapped
    case setMember(Member)
  }

  @Dependency(\.network) var network
  @Dependency(\.dismiss) var dismiss

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let memberDTO = try await network.request(MemberAPI.fetch(id: 1), type: MemberDTO.self)
          let member = memberDTO.toDomain
          await send(.setMember(member))
        }

      case .dismissButtonTapped:
        return .run { send in
          await dismiss()
        }

      case .confirmButtonTapped:
        print("확인 버튼 클릭")
        return .run { send in
          // TODO: 회원 이미지 데이터를 보내야함 + UpdateRequestDTO 처리
          try await network.request(MemberAPI.update(id: 1))
          await dismiss()

        } catch: { error, send in
          print(error)
        }

      case .selectInPhotoLibraryButtonTapped:
        // TODO: 사진첩에서 선택하기 버튼 클릭
        return .none

      case .takePhotoButtonTapped:
        // TODO: 촬영하기 버튼 클릭
        return .none

      case .deleteCurrentPhotoButtonTapped:
        // TODO: 현재 사진 삭제 버튼 클릭
        return .none

      case .binding:
        return .none

      case .logoutButtonTapped:
        return .run { send in
          // TODO: 로그아웃 처리
        }

      case .deactivateButtonTapped:
        return .run { send in
          // TODO: 서비스 탈퇴 Sheet에서 "확인" 클릭 시 처리
          try await network.request(MemberAPI.delete(id: 1))

        } catch: { error, send in
          // TODO: 에러 처리
          print(error)
        }

      case .setMember(let member):
        state.member = member
        state.nickName = member.nickName
        state.introduction = member.introduction
        state.imageURL = member.imageURL

        return .none
      }
    }
  }
}
