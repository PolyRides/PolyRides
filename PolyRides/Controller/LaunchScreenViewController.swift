//
//  LaunchScreenViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FirebaseDatabase

class LaunchScreenViewController: LoadingViewController {

  let ref = FIRDatabase.database().reference()

  override func viewDidLoad() {
    super.viewDidLoad()

//    if user?.id != nil {
//      self.startLoadingData()
//    } else
//
//    if user?.facebookId != nil {
//      userService.getUserId(user: user!)
//    } else {
//      userService.logOut()
//    }
  }

}
