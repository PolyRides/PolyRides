//
//  RidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/16/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class MyRidesViewController: RidesViewController {

  var currentRides = [Ride]()
  var pastRides = [Ride]()
  var savedRides = [Ride]()
  var expectedRides = -1 {
    didSet {
      if expectedRides == 0 {
        // Set empty data set delegates
        rides = currentRides
        tableView?.reloadData()
      }
    }
  }

  @IBAction func segmentedAction(sender: AnyObject) {
    if let segmentedControl = sender as? UISegmentedControl {
      if segmentedControl.selectedSegmentIndex == 0 {
        rides = currentRides
      } else if segmentedControl.selectedSegmentIndex == 1 {
        rides = pastRides
      } else {
        rides = savedRides
      }
    }
    tableView?.reloadData()
  }

  // TODO: Remove this when we add log out to settings.
  @IBAction func logOutAction(sender: AnyObject) {
    if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
      let storyboard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
      if let navVC = storyboard.instantiateViewControllerWithIdentifier("Login") as? UINavigationController {
        if let vc = navVC.topViewController as? LoginViewController {
          FirebaseConnection.service.ref.unauth()
          appDelegate.window?.rootViewController = vc
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }

    FirebaseConnection.service.ridesDelegate = self
    if let user = user {
      FirebaseConnection.service.getRidesForUser(user)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toAddRide" {
      if let navVC = segue.destinationViewController as? UINavigationController {
        if let addRideVC = navVC.topViewController as? AddRideViewController {
          addRideVC.user = user
        }
      }
    } else if segue.identifier == "toRideDetails" {
      if let vc = segue.destinationViewController as? RideDetailsViewController {
        if let cell = sender as? RideTableViewCell {
          vc.ride = cell.ride
          vc.user = user
        }
      }
    }
  }

}

// MARK: - FirebaseRidesDelegate
extension MyRidesViewController: FirebaseRidesDelegate {

  func onRideReceived(ride: Ride) {
    if ride.date?.compare(NSDate()) == .OrderedDescending {
      currentRides.append(ride)
    } else {
      pastRides.append(ride)
    }
    expectedRides -= 1
  }

  func onNumRidesReceived(numRides: Int) {
    expectedRides = numRides
  }

  func onRideAdded(ride: Ride) {
    if ride.date?.compare(NSDate()) == .OrderedDescending {
      currentRides.append(ride)
    } else {
      pastRides.append(ride)
    }
    tableView?.reloadData()
  }

}
