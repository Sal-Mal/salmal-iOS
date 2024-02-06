import UIKit

import ThirdPartyLibs
import FirebaseCore
import FirebaseMessaging

import Core

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    application.registerForRemoteNotifications()
    
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
      // empty
    }

    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.badge, .banner, .list, .sound]
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    let userInfo = response.notification.request.content.userInfo

    if let commentID = userInfo["issuedContent"] as? String, Int(commentID) != nil,
       let alarmID = userInfo["notificationId"] as? String,
       let voteID = userInfo["contentId"] as? String, Int(voteID) != nil
    {
      AppState.shared.alarmData = .init(
        voteID: Int(voteID)!,
        commentID: Int(commentID)!,
        alarmID: alarmID,
        step: .home
      )
    }
  }
  
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any]
  ) async -> UIBackgroundFetchResult {
    print(userInfo)
    return .newData
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let fcmToken, UserDefaultsService.shared.fcmToken != fcmToken else { return }
    
    UserDefaultsService.shared.fcmToken = fcmToken
    
    Task {
      let repo = NotificationRepositoryImpl(networkManager: DefaultNetworkService())
      try await repo.registerFCM(token: fcmToken)
    }
  }
}
