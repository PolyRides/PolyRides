//
//  UserProfileViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/23/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FBSDKLoginKit

class MyProfileViewController: ProfileViewController {

  @IBAction func logOutAction(sender: AnyObject) {
    UserService().logOut()
  }

  override func viewDidLoad() {
    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }

    super.viewDidLoad()

    setupAppearance()

    if user?.verifications.index(of: Verification.CalPoly) != nil {
      verifiedImage?.isHidden = false
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toEditProfile" {
      if let navVC = segue.destination as? UINavigationController {
        if let vc = navVC.topViewController as? EditProfileViewController {
          vc.user = user
          vc.delegate = self
        }
      }
    }
  }
}

// MARK: - EditProfileDelegate
extension MyProfileViewController: EditProfileDelegate {

  func onProfileSaved() {
    setupProfile()
  }

}
