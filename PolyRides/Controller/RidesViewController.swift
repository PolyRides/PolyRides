//
//  RidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/16/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

<<<<<<< HEAD
class RidesViewController: UIViewController {

  var user: User?
  var rides = [Ride]()

  @IBOutlet weak var tableView: UITableView?
=======
import GooglePlacesAutocomplete

class RidesViewController: UIViewController {

  var user: User?

>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df

  override func viewDidLoad() {
    super.viewDidLoad()

<<<<<<< HEAD
    if let tabBarController = self.tabBarController as? TabBarController {
      self.user = tabBarController.user
    }

    tableView?.delegate = self
    tableView?.dataSource = self

    // query for all rides
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toAddRide" {
      if let navVC = segue.destinationViewController as? UINavigationController {
        if let addRideVC = navVC.topViewController as? AddRideViewController {
          addRideVC.user = user
        }
      }
    }
  }

}


// MARK: - UITableViewDataSource
extension RidesViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rides.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("rideCell", forIndexPath: indexPath)
  }

}

// MARK: - UITableViewDelegate
extension RidesViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print("selected a ride")
  }
  
=======
    // populate user field from tab bar controller
    // query for all rides
  }

>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
}
