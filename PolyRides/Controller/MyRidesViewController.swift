//
//  RidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/16/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class MyRidesViewController: RidesViewController {

  var rideService = RideService()

  var currentRides = [Ride]() {
    didSet {
      if segmentedControl?.selectedSegmentIndex == 0 {
        sortRides(&currentRides)
        rides = currentRides
        tableView?.reloadData()
      }
    }
  }
  var pastRides = [Ride]() {
    didSet {
      if segmentedControl?.selectedSegmentIndex == 1 {
        sortRides(&pastRides)
        rides = pastRides
        tableView?.reloadData()
      }
    }
  }
  var savedRides = [Ride]() {
    didSet {
      if segmentedControl?.selectedSegmentIndex == 2 {
        sortRides(&savedRides)
        rides = savedRides
        tableView?.reloadData()
      }
    }
  }
  var expectedRides = -1 {
    didSet {
      if expectedRides == 0 {
        // Set empty data set delegates
        rides = currentRides
        tableView?.reloadData()
      }
    }
  }

  @IBOutlet weak var segmentedControl: UISegmentedControl?

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
        FirebaseConnection.ref.unauth()
        appDelegate.window?.rootViewController = navVC
      }
    }
  }

  @IBAction func addRide(segue: UIStoryboardSegue) {
    if let addRideVC = segue.sourceViewController as? AddRideViewController {
      if let ride = addRideVC.ride {
        if ride.date?.compare(NSDate()) == .OrderedDescending {
          currentRides.append(ride)
        } else {
          pastRides.append(ride)
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }

    rideService.delegate = self
    if let user = user {
      rideService.getRidesForUser(user)
      rideService.getSavedRidesForUser(user)
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

  func sortRides(inout rides: [Ride]) {
    rides.sortInPlace({ (ride1, ride2) -> Bool in
      if let date1 = ride1.date {
        if let date2 = ride2.date {
          return date1.compare(date2) == .OrderedAscending
        }
      }
      return true
    })
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

  func onSavedRidesReceived(rides: [Ride]) {
    savedRides = rides
  }

}
