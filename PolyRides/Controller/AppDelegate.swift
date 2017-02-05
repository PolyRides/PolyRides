//
//  AppDelegate.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/11/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Siren
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMaps
import GooglePlaces
import SendGrid
import FirebaseDatabase
import FirebaseAuth
import FirebaseAnalytics
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let gcmMessageIDKey = "gcm.message_id"


  override init() {
    super.init()
    FIRApp.configure()
    // Register with Google Maps.
    GMSPlacesClient.provideAPIKey("AIzaSyAIlHfqVp18wk-J-lvbnpMyxyI5z1bO4pk")
    GMSServices.provideAPIKey("AIzaSyAIlHfqVp18wk-J-lvbnpMyxyI5z1bO4pk")
  }

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    FBSDKApplicationDelegate.sharedInstance()
      .application(application, didFinishLaunchingWithOptions: launchOptions)

    // Tab bar appearance.
    UITabBarItem.appearance().setTitleTextAttributes(Attributes.TabBar, for: .normal)

    // Navigation bar appearance.
    UINavigationBar.appearance().titleTextAttributes = Attributes.NavigationBar
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white


 //   UIScrollView.appearance().backgroundColor = Color.White

    // SendGrid.
    _ = Session(auth: Authentication.apiKey("pQRGWenNRPKfEwwKQ2MjkQ"))

    // Google Analytics.
//    var configureError: NSError?
//    GAI.sharedInstance().configureWithError(&configureError)
//    assert(configureError == nil, "Error configuring Google services: \(configureError)")

    let gai = GAI.sharedInstance()
    gai?.trackUncaughtExceptions = true  // Report uncaught exceptions.
    _ = gai?.tracker(withTrackingId: "UA-69182247-4")

    // Siren
    let siren = Siren.sharedInstance
    siren.alertType = SirenAlertType.force
    siren.checkVersion(checkType: .immediately)
    
    if let currentUser = FIRAuth.auth()?.currentUser {
      let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
      if let controller = storyboard.instantiateInitialViewController() as? LaunchScreenViewController {
        let user = User()

        print("IN HERE")

        if let profile = currentUser.providerData.first {
          user.facebookId = profile.uid
        }

        controller.user = user
        self.window?.rootViewController = controller
      }
    }

    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    if #available(iOS 10.0, *) {
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })

      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      // For iOS 10 data message (sent via FCM)
      FIRMessaging.messaging().remoteMessageDelegate = self


    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    application.registerForRemoteNotifications()

    // [END register_for_notifications]

    // [START add_token_refresh_observer]
    // Add observer for InstanceID token refresh callback.
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.tokenRefreshNotification),
                                           name: .firInstanceIDTokenRefresh,
                                           object: nil)
    // [END add_token_refresh_observer]


    // Fabric (must be the last call in didFinishLaunchingWithOptions).
    Fabric.with([Crashlytics.self])

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for
    // certain types of temporary interruptions (such as an incoming phone call or SMS message) or
    // when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame
    // rates. Games should use this method to pause the game.

    FBSDKAppEvents.activateApp()
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store
    // enough application state information to restore your application to its current state in case
    // it is terminated later.
    // If your application supports background execution, this method is called instead of
    // applicationWillTerminate: when the user quits.

    FIRMessaging.messaging().disconnect()
    print("Disconnected from FCM.")
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo
    // many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.

    connectToFcm()
    FBSDKAppEvents.activateApp()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also
    // applicationDidEnterBackground:.
  }

  func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                   annotation: Any) -> Bool {
      return FBSDKApplicationDelegate.sharedInstance()
        .application(application, open: url as URL!,
          sourceApplication: sourceApplication, annotation: annotation)
  }

  // [START receive_message]
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler(UIBackgroundFetchResult.newData)
  }
  // [END receive_message]

  // [START refresh_token]
  func tokenRefreshNotification(_ notification: Notification) {
    if let refreshedToken = FIRInstanceID.instanceID().token() {
      print("InstanceID token: \(refreshedToken)")
    }

    // Connect to FCM since connection may have failed when attempted before having a token.
    connectToFcm()
  }
  // [END refresh_token]

  // [START connect_to_fcm]
  func connectToFcm() {
    // Won't connect since there is no token
    guard FIRInstanceID.instanceID().token() != nil else {
      return;
    }

    // Disconnect previous FCM connection if it exists.
    FIRMessaging.messaging().disconnect()

    FIRMessaging.messaging().connect { (error) in
      if error != nil {
        print("Unable to connect with FCM. \(error)")
      } else {
        print("Connected to FCM.")
      }
    }
  }
  // [END connect_to_fcm]

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Swift.Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }

  // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
  // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
  // the InstanceID token.
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")

    // With swizzling disabled you must set the APNs token here.
    // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
  }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
  // Receive data message on iOS 10 devices while app is in the foreground.
  func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
    print(remoteMessage.appData)
  }
}
// [END ios_10_data_message_handling]
