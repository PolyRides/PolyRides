//
//  SearchTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class SearchTableViewController: UITableViewController {

  var user: User?

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toLogOut" {
      FirebaseConnection.ref.unauth()
    }
  }

}
