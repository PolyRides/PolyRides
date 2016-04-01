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
    super.viewDidLoad()

  }
}
