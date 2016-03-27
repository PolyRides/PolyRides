//
//  RidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/16/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class MyRidesViewController: RidesViewController {

  var rideService = RideService()
  var currentRides = [Ride]()
  var pastRides = [Ride]()
  var expectedRides = -1 {
    didSet {
      if expectedRides == 0 {
        // set empty data set
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
        rides = user?.savedRides
      }
    }
    tableView?.reloadData()
  }

  // Remove this when we add log out to settings.
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
          sortRides(&currentRides)
        } else {
          pastRides.append(ride)
          sortRides(&pastRides)
        }

        if let segmentedControl = segmentedControl {
          segmentedAction(segmentedControl)
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }

    tableView?.delegate = self
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
    } else if segue.identifier == "toPassengerRideDetails" || segue.identifier == "toDriverRideDetails" {
      if let tabVC = segue.destinationViewController as? UITabBarController {
        if let navVC = tabVC.viewControllers?.first as? UINavigationController {
          if let vc = navVC.topViewController as? RideDetailsViewController {
            if let cell = sender as? RideTableViewCell {
              vc.ride = cell.ride
              vc.user = user
            }
          }
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

}

// MARK: - UITableViewDelegate
extension MyRidesViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    if segmentedControl?.selectedSegmentIndex == 2 {
      performSegueWithIdentifier("toPassengerRideDetails", sender: cell)
    } else {
      performSegueWithIdentifier("toDriverRideDetails", sender: cell)
    }
  }

}
