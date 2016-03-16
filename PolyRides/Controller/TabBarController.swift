//
//  TabBarViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/15/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class TabBarController: UITableViewController {

  var user: User?

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBar.hidden = false
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toLogOut" {
      FirebaseConnection.ref.unauth()
    }
  }

}
