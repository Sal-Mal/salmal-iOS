import Foundation
import ComposableArchitecture

import UI

public struct SettingCore: Reducer {
  
  public struct State: Equatable {

    public struct SettingMenu: Equatable, Identifiable {
      public let id: UUID = .init()
      public let title: String
      public let icon: SM.Icon
      public var state: ProfileCore.Path.State?
    }

    var menus: IdentifiedArrayOf<SettingMenu> = [
      .init(title: "개인정보 수정", icon: .ic_edit, state: .profileEdit()),
      .init(
        title: "이용약관 및 개인정보 처리 방침",
        icon: .ic_component,
        state: .web(.init(title: "이용약관 및 개인정보 처리 방침", urlString: "https://www.naver.com/"))
      ),
      .init(
        title: "개발자한테 연락하기",
        icon: .ic_send,
        state: .web(.init(title: "개발자한테 연락하기", urlString: "https://open.kakao.com/o/sVNGzjSf"))
      ),
      .init(
        title: "E-mail 및 SMS 광고성 정보 수신동의",
        icon: .ic_send,
        state: .web(.init(title: "E-mail 및 SMS 광고성 정보", urlString: "https://www.naver.com/"))
      ),
      .init(title: "차단한 사용자 목록", icon: .ic_send, state: .blockedMemberList()),
    ]

    public init() {}
  }
  
  public enum Action {
    case backButtonTapped
  }

  @Dependency(\.dismiss) var dismiss

  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await self.dismiss()
        }
      }
    }
  }
}
