//
//  UserProfileViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/23/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FBSDKLoginKit

class MyProfileViewController: ProfileViewController {

  @IBOutlet weak var carDetailsLabel: UILabel?

  @IBAction func logOutAction(sender: AnyObject) {
    UserService().logOut()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupProfile() {
    super.setupProfile()

    if let description = user?.description {
      descriptionTextView?.text = description
    }
    if let carDetails = user?.car?.getDescription() {
      carDetailsLabel?.text = carDetails
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toEditProfile" {
      if let navVC = segue.destinationViewController as? UINavigationController {
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
