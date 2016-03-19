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
<<<<<<< HEAD
      FirebaseConnection.service.ref.unauth()
=======
      FirebaseConnection.ref.unauth()
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
    }
  }

}
