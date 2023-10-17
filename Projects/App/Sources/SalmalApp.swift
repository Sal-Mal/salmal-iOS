import SwiftUI

import UI
import Core

import LoginFeature
import MainFeature
import ProfileFeature

@main
struct SalmalApp: App {
  @State private var isLogined = false
  @State private var tabIndex = 0
  
  init() {
    SM.Font.initFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      Group {
        if isLogined {
          
          TabView(selection: $tabIndex) {
            SalMalView(store: .init(initialState: .init()) {
              SalMalCore()
            })
            .tabItem {
              Image(icon: tabIndex == 0 ? .home_fill : .home)
                .fit(size: 32)
            }
            .tag(0)
            
            Rectangle()
            .tabItem {
              Image(icon: tabIndex == 1 ? .plus_circle : .plus)
                .fit(size: 32)
            }
            .tag(1)
            
            ProfileView(store: .init(initialState: .init()) {
              ProfileCore()
            })
            .tabItem {
              Image(icon: tabIndex == 2 ? .person_fill : .person)
                .fit(size: 32)
            }
            .tag(2)
          }
          
        } else {
          SplashView(store: .init(initialState: .init()) {
            SplashCore()
          })
        }
      }
      .preferredColorScheme(.dark)
      .onReceive(NotificationCenter.default.publisher(for: .init("login"))) { _ in
        isLogined = true
      }
      .onReceive(NotificationCenter.default.publisher(for: .init("logout"))) { _ in
        isLogined = false
      }
    }
  }
}
