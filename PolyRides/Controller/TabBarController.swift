//
//  TabBarViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/15/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class TabBarController: UITabBarController {

  var user: User?

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBar.hidden = false
  }

<<<<<<< HEAD
=======
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toLogin" {
      FirebaseConnection.ref.unauth()
    }
  }

>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
}
