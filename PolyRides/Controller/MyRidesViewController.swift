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

  @IBAction func unwindToMyRidesViewController(segue: UIStoryboardSegue) {
    if let myRide = segue.source as? MyRideDetailsViewController {
      if let ride = myRide.ride {
        if let user = myRide.user {

          // driver deleting a ride
          var confAlert = UIAlertController(title: "Confirmation", message: "Are you sure you would like to remove this ride? This action cannot be undone.", preferredStyle: UIAlertControllerStyle.alert)

          confAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            self.leaveOrRemove(ride: ride, user: user)
            // for each passenger, send them a notification
            for passenger in ride.passengers {
              // get the instanceID from the key
              self.rideService.getInstanceIdFromId(ride: ride, user: user, id: passenger.key)
            }

            var leftAlert = UIAlertController(title: "Success", message: "You successfully removed this ride.", preferredStyle: UIAlertControllerStyle.alert)
            leftAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(leftAlert, animated: true, completion: nil)
          }))

          confAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          }))
          
          self.present(confAlert, animated: true, completion: nil)
        }
      } else {
        let title = "Error Removing Ride"
        let message = "There was an error removing this ride. Please try again."
        presentAlert(alertOptions: AlertOptions(message: message, title: title))
      }
    }
    if let passRide = segue.source as? PassengerRideDetailsViewController {
      if let ride = passRide.ride {
        if let user = passRide.user {
          leaveOrRemove(ride: ride, user: user)
          let jsonDict = ["data": ["leavingRide": "true", "user":"\(user.getFullName())", "toPlaceCity": "\(ride.toLocation!.city!))", "fromPlaceCity": "\(ride.fromLocation!.city!)", "userId": "\(user.id!)", "rideId": "\(ride.id!)", "userInstanceId": "\(user.instanceID!)"], "to": "\(ride.getDriverInstanceID())"] as [String : Any]
          HTTPHelper.sendHTTPPost(jsonDict: jsonDict)
        }
      } else {
        let title = "Error Leaving Ride"
        let message = "There was an error leaving this ride. Please try again."
        presentAlert(alertOptions: AlertOptions(message: message, title: title))
      }
    }
  }

  func leaveOrRemove(ride: Ride, user: User) {
    if ride.driverId == user.id {
      // if it is the driver removing the ride
      RideService().removeRide(ride: ride)
    } else {
      // remove the passenger from the ride
      RideService().removePassengerFromRide(ride: ride, passenger: user)
    }

    findAndRemoveRide(rideToRemove: ride)
  }

  func findAndRemoveRide(rideToRemove: Ride) {
    //find the ride, remove it from the array
    while (rides?.contains(rideToRemove))! {
      if let itemToRemoveIndex = rides?.index(of: rideToRemove) {
        rides!.remove(at: itemToRemoveIndex)
      }
    }

    //find the ride, remove it from the array
    while currentRides.contains(rideToRemove) {
      if let itemToRemoveIndex = currentRides.index(of: rideToRemove) {
        currentRides.remove(at: itemToRemoveIndex)
      }
    }

    //find the ride, remove it from the array
    while pastRides.contains(rideToRemove) {
      if let itemToRemoveIndex = pastRides.index(of: rideToRemove) {
        pastRides.remove(at: itemToRemoveIndex)
      }
    }
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
      rideService.monitorRidesForUser(user: user)
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

    tableView?.reloadData()
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
      if let vc = segue.destination as? PassengerRideDetailsViewController {
        if let cell = sender as? RideTableViewCell {
          let isPassenger = cell.ride?.passengers.contains { (key, value) -> Bool in
            key == user?.id
          }
          if let isPassenger = isPassenger {
            if isPassenger == true {
              vc.isAlreadyInRides = true
            }
          }
        }
      }

      if let vc = segue.destination as? RideDetailsViewController {
        if let cell = sender as? RideTableViewCell {
          vc.ride = cell.ride
          vc.user = user
          vc.segmentedControl = segmentedControl
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
      if !currentRides.contains(ride) {
        currentRides.append(ride)
      }
    } else {
      if !pastRides.contains(ride) {
        pastRides.append(ride)
      }
    }
    expectedRides -= 1
  }

  func onRideRemoved(ride: Ride) {
    if ride.date?.compare(NSDate() as Date) == .orderedDescending {
      if currentRides.contains(ride) {
        currentRides.remove(at: (currentRides.index(of: ride))!)
      }
    } else {
      if pastRides.contains(ride) {
        pastRides.remove(at: (currentRides.index(of: ride))!)
      }
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

    if let cell = cell as? RideTableViewCell {
      // if it is a favorited ride, or the user is a passenger in the ride
      if segmentedControl?.selectedSegmentIndex == 2 || cell.ride?.driverId != user?.id {
        performSegue(withIdentifier: "toPassengerRideDetails", sender: cell)
      } else {
        performSegue(withIdentifier: "toMyRideDetails", sender: cell)
      }
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
      transition.bubbleColor = Color.Green
      return transition
  }

  func animationControllerForDismissedController(dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .dismiss
      if let addButton = addButton {
        transition.startingPoint = addButton.center
      }
      transition.bubbleColor = Color.Green
      return transition
  }

}
