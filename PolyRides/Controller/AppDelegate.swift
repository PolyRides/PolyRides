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
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  override init() {
    super.init()

    // Firebase
    FIRApp.configure()
    
    // Register with Google Maps.
    GMSPlacesClient.provideAPIKey("AIzaSyAIlHfqVp18wk-J-lvbnpMyxyI5z1bO4pk")
    GMSServices.provideAPIKey("AIzaSyAIlHfqVp18wk-J-lvbnpMyxyI5z1bO4pk")
  }

  private func application(application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {

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

        if let profile = currentUser.providerData.first {
          user.facebookId = profile.uid
        }

        controller.user = user
        self.window?.rootViewController = controller
      }
    }

    // Fabric (must be the last call in didFinishLaunchingWithOptions).
    Fabric.with([Crashlytics.self])

    // Keyboard manager
    IQKeyboardManager.sharedManager().enable = true

    FBSDKApplicationDelegate.sharedInstance()
      .application(application, didFinishLaunchingWithOptions: launchOptions)

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
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo
    // many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.

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

}
