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
    if let addRideVC = segue.source as? AddRideViewController {
      if let ride = addRideVC.ride {
        if ride.date?.compare(NSDate() as Date) == .orderedDescending {
          currentRides.append(ride)
          sortRides(rides: &currentRides)
        } else {
          pastRides.append(ride)
          sortRides(rides: &pastRides)
        }

        if let segmentedControl = segmentedControl {
          segmentedAction(sender: segmentedControl)
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
      rideService.getRidesForUser(user: user)
      rideService.getSavedRidesForUser(user: user)
    }

    emptyImage = "empty"
    if let addButton = addButton {
      addButton.clipsToBounds = true
      addButton.layer.cornerRadius = addButton.layer.frame.size.width / 2
    }
    setupAppearance()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let segmentedControl = segmentedControl {
      segmentedAction(sender: segmentedControl)
    }
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toAddRide" {
      if let navVC = segue.destination as? UINavigationController {
        if let vc = navVC.topViewController as? AddRideViewController {
          vc.user = user

        }
        navVC.transitioningDelegate = self
        navVC.modalPresentationStyle = .custom
      }
    } else if segue.identifier == "toPassengerRideDetails" || segue.identifier == "toMyRideDetails" {
      if let vc = segue.destination as? RideDetailsViewController {
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

  func sortRides(rides: inout [Ride]) {
    rides.sort(by: { (ride1, ride2) -> Bool in
      if let date1 = ride1.date {
        if let date2 = ride2.date {
          return date1.compare(date2 as Date) == .orderedAscending
        }
      }
      return true
    })
  }

}

// MARK: - FirebaseRidesDelegate
extension MyRidesViewController: FirebaseRidesDelegate {

  func onRideReceived(ride: Ride) {
    if ride.date?.compare(NSDate() as Date) == .orderedDescending {
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    tableView.deselectRow(at: indexPath, animated: true)

    if segmentedControl?.selectedSegmentIndex == 2 {
      performSegue(withIdentifier: "toPassengerRideDetails", sender: cell)
    } else {
      performSegue(withIdentifier: "toMyRideDetails", sender: cell)
    }
  }

}

// MARK: - UIViewControllerTransitioningDelegate
extension MyRidesViewController: UIViewControllerTransitioningDelegate {

  func animationControllerForPresentedController(presented: UIViewController,
                                                 presentingController presenting: UIViewController,
                                                                      sourceController source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .present
      if let addButton = addButton {
        transition.startingPoint = addButton.center
      }
      transition.bubbleColor = Color.Navy
      return transition
  }

  func animationControllerForDismissedController(dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .dismiss
      if let addButton = addButton {
        transition.startingPoint = addButton.center
      }
      transition.bubbleColor = Color.Navy
      return transition
  }

}
