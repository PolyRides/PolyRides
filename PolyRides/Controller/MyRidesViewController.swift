//
//  MyRidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/16/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import BubbleTransition

class MyRidesViewController: RidesTableViewController {

  @IBOutlet weak var segmentedControl: UISegmentedControl?
  @IBOutlet weak var addButton: UIButton?

  @IBAction func segmentedAction(sender: AnyObject) {
    if let segmentedControl = sender as? UISegmentedControl {
      if segmentedControl.selectedSegmentIndex == 0 {
        rides = currentRides
        emptyTitle = Empty.CurrentRidesTitle
        emptyMessage = Empty.CurrentRidesMessage
      } else if segmentedControl.selectedSegmentIndex == 1 {
        rides = pastRides
        emptyTitle = Empty.PastRidesTitle
        emptyMessage = Empty.PastRidesMessage
      } else {
        rides = user?.savedRides
        emptyTitle = Empty.SavedRidesTitle
        emptyMessage = Empty.SavedRidesMessage
      }
    }
    tableView?.reloadData()
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

  let transition = BubbleTransition()

  var rideService = RideService()
  var currentRides = [Ride]()
  var pastRides = [Ride]()
  var expectedRides = -1 {
    didSet {
      if expectedRides == 0 {
        rides = currentRides
        tableView?.reloadData()
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

    emptyImage = "empty"
    if let addButton = addButton {
      addButton.clipsToBounds = true
      addButton.layer.cornerRadius = addButton.layer.frame.size.width / 2
    }
    setupAppearance()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let segmentedControl = segmentedControl {
      segmentedAction(segmentedControl)
    }
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toAddRide" {
      if let navVC = segue.destinationViewController as? UINavigationController {
        if let vc = navVC.topViewController as? AddRideViewController {
          vc.user = user

        }
        navVC.transitioningDelegate = self
        navVC.modalPresentationStyle = .Custom
      }
    } else if segue.identifier == "toPassengerRideDetails" || segue.identifier == "toMyRideDetails" {
      if let vc = segue.destinationViewController as? RideDetailsViewController {
        if let cell = sender as? RideTableViewCell {
          vc.ride = cell.ride
          vc.user = user
        }
      }

      let backItem = UIBarButtonItem()
      backItem.title = ""
      navigationItem.backBarButtonItem = backItem
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
      performSegueWithIdentifier("toMyRideDetails", sender: cell)
    }
  }

}

// MARK: - UIViewControllerTransitioningDelegate
extension MyRidesViewController: UIViewControllerTransitioningDelegate {

  func animationControllerForPresentedController(presented: UIViewController,
                                                 presentingController presenting: UIViewController,
                                                                      sourceController source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .Present
      if let addButton = addButton {
        transition.startingPoint = addButton.center
      }
      transition.bubbleColor = Color.Navy
      return transition
  }

  func animationControllerForDismissedController(dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .Dismiss
      if let addButton = addButton {
        transition.startingPoint = addButton.center
      }
      transition.bubbleColor = Color.Navy
      return transition
  }

}
