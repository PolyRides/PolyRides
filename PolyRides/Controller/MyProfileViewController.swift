//
//  UserProfileViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/23/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FBSDKLoginKit

class MyProfileViewController: ProfileViewController {

  @IBOutlet weak var connectToFacebookStackView: UIStackView?

  @IBAction func logOutAction(sender: AnyObject) {
    if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
      let storyboard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
      if let navVC = storyboard.instantiateViewControllerWithIdentifier("Login") as? UINavigationController {
        FirebaseConnection.ref.unauth()
        appDelegate.window?.rootViewController = navVC
      }
    }
  }

  @IBAction func connectToFacebookAction(sender: AnyObject) {
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if FBSDKAccessToken.currentAccessToken() != nil {
      connectToFacebookStackView?.hidden = true
    }
  }
}
