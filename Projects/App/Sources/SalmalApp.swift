import SwiftUI

import ComposableArchitecture
import UI
import Core

import LoginFeature
import MainFeature
import ProfileFeature
import UploadFeature

@main
struct SalmalApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  @State private var isLogined = false
  @State private var isUploadPresented = false
  @State private var tabIndex: TabItem = .home
  @State private var showTab = true
  
  @State private var mainStore: StoreOf<SalMalCore>! = .init(initialState: .init()) { SalMalCore() }
  @State private var profileStore: StoreOf<ProfileCore>! = .init(initialState: .init()) { ProfileCore() }
  @State private var uploadStore: StoreOf<UploadCore>! = .init(initialState: .init()) { UploadCore() }
  @State private var splashStore: StoreOf<SplashCore>! = .init(initialState: .init()) { SplashCore() }
  
  @Dependency(\.kakaoManager) var kakaoManager
  
  init() {
    SM.Font.initFonts()
    kakaoManager.initSDK()
  }
  
  var body: some Scene {
    WindowGroup {
      Group {
        if isLogined {
          MainScene
        } else {
          SplashScene
        }
      }
      .onOpenURL(perform: kakaoManager.openURL)
      .preferredColorScheme(.dark)
      .onReceive(NotificationService.publisher(.login)) { _ in
        isLogined = true
        
        mainStore = .init(initialState: .init()) { SalMalCore() }
        profileStore = .init(initialState: .init()) { ProfileCore() }
        uploadStore = .init(initialState: .init()) { UploadCore() }
        splashStore = nil
        
        tabIndex = .home
      }
      .onReceive(NotificationService.publisher(.logout)) { _ in
        isLogined = false
        
        mainStore = nil
        profileStore = nil
        uploadStore = nil
        splashStore = .init(initialState: .init()) { SplashCore() }
      }
    }
  }
}

extension SalmalApp {
  var MainScene: some View {
    VStack {
      switch tabIndex {
      case .home:
        SalMalView(store: mainStore)
      case .profile:
        ProfileView(store: profileStore)
      }
      
      Spacer()
      
      SalMalTabBar(tabIndex: $tabIndex) {
         isUploadPresented = true
      }
      .opacity(showTab ? 1 : 0)
    }
    .animation(.none, value: tabIndex)
    .onReceive(NotificationService.publisher(.showTabBar)) { _ in
      showTab = true
    }
    .onReceive(NotificationService.publisher(.hideTabBar)) { _ in
      showTab = false
    }
    .fullScreenCover(isPresented: $isUploadPresented) {
      UploadView(store: uploadStore)
    }
  }
  
  var SplashScene: some View {
    SplashView(store: splashStore)
  }
}
