//
//  TabBarViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/15/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class TabBarController: UITabBarController {

  let locationManager = CLLocationManager()

  var user: User?

  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager.requestWhenInUseAuthorization()

    viewControllers?.forEach {
      if let vc = $0 as? UINavigationController {
        vc.topViewController?.view
      }
    }

    if let user = user {
      FirebaseConnection.service.updateValuesForUser(user)
      FirebaseConnection.service.getAllRides()
    } else {
      let message = "Please log out and try again."
      let title = "Authentication Error"
      presentAlert(AlertOptions(message: message, title: title, acceptText: "Log Out", handler: logOut))
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBarHidden = false
  }

  func logOut(action: UIAlertAction) {
    if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
      let storyboard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
      if let navVC = storyboard.instantiateViewControllerWithIdentifier("Login") as? UINavigationController {
        if let vc = navVC.topViewController as? LoginViewController {
          FirebaseConnection.service.ref.unauth()
          appDelegate.window?.rootViewController = vc
        }
      }
    }
  }

}
