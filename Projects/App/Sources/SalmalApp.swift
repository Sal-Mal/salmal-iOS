import SwiftUI

import ComposableArchitecture
import UI
import Core

import LoginFeature
import MainFeature
import ProfileFeature

@main
struct SalmalApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  @State private var isLogined = false
  @State private var tabIndex = 0
  @Dependency(\.kakaoManager) var kakaoManager
  
  init() {
    SM.Font.initFonts()
    kakaoManager.initSDK()
  }
  
  var body: some Scene {
    WindowGroup {
      AppView
        .onOpenURL(perform: kakaoManager.openURL)
        .preferredColorScheme(.dark)
        .onReceive(NotificationCenter.default.publisher(for: .init("login"))) { _ in
          isLogined = true
          tabIndex = 0
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("logout"))) { _ in
          isLogined = false
        }
    }
  }
  
  private let mainStore: StoreOf<SalMalCore> = .init(initialState: .init()) {
    SalMalCore()
  }
  
  private let profileStore: StoreOf<ProfileCore> = .init(initialState: .init()) {
    ProfileCore()
  }
  
  @ViewBuilder
  var AppView: some View {
    if isLogined {
      MainScene
    } else {
      SplashScene
    }
  }
  
  var MainScene: some View {
    TabView(selection: $tabIndex) {
      SalMalView(store: mainStore)
        .tabItem {
          Image(icon: tabIndex == 0 ? .home_fill : .home)
            .fit(size: 32)
        }
        .toolbarBackground(.hidden, for: .tabBar)
        .tag(0)
      
      Rectangle()
        .tabItem {
          Image(icon: .ic_upload_circle)
            .fit(size: 32)
        }
        .toolbarBackground(.hidden, for: .tabBar)
        .tag(1)
      
      ProfileView(store: profileStore)
        .tabItem {
          Image(icon: tabIndex == 2 ? .person_fill : .person)
            .fit(size: 32)
        }
        .toolbarBackground(.hidden, for: .tabBar)
        .tag(2)
    }
  }
  
  var SplashScene: some View {
    SplashView(store: .init(initialState: .init()) {
      SplashCore()
    })
  }
}
