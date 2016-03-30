//
//  RidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/16/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import DZNEmptyDataSet

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

    tableView?.emptyDataSetSource = self
    tableView?.delegate = self
    rideService.delegate = self
    if let user = user {
      rideService.getRidesForUser(user)
      rideService.getSavedRidesForUser(user)
    }

    // Remove the cell separators in the empty table view.
    tableView?.tableFooterView = UIView()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let segmentedControl = segmentedControl {
      segmentedAction(segmentedControl)
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

// MARK: - DZNEmptyDataSetDataSource
extension MyRidesViewController: DZNEmptyDataSetSource {

  func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: "empty")
  }

  func imageAnimationForEmptyDataSet(scrollView: UIScrollView!) -> CAAnimation! {
    let animation = CABasicAnimation(keyPath: "transform")

    animation.fromValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
    animation.duration = 0.25
    animation.cumulative = true
    animation.repeatCount = MAXFLOAT

    return animation
  }


  func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let attributes = [
      NSFontAttributeName: UIFont.systemFontOfSize(18),
      NSForegroundColorAttributeName : UIColor.blackColor()]
    var message = "You haven't posted any rides, yet."
    if segmentedControl?.selectedSegmentIndex == 1 {
      message = "You haven't completed any rides, yet."
    } else if segmentedControl?.selectedSegmentIndex == 2 {
      message = "You haven't saved any rides, yet."
    }
    return NSAttributedString(string: message, attributes: attributes)
  }

  func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    var message = ""
    if segmentedControl?.selectedSegmentIndex == 0 {
      message = "Offer a ride by tapping the plus symbol\nin the top right."
    } else if segmentedControl?.selectedSegmentIndex == 1 {
      message = "When you offer and complete a ride,\nthat ride will appear here."
    } else {
      message = "When viewing a ride in the search tab, you may save a ride by tapping the star in the top right."
    }

    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
    paragraph.alignment = NSTextAlignment.Center
    let attributes = [
      NSFontAttributeName: UIFont.systemFontOfSize(14),
      NSForegroundColorAttributeName: UIColor.grayColor(),
      NSParagraphStyleAttributeName: paragraph]

    return NSAttributedString(string: message, attributes: attributes)
  }

  func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
    return UIColor.whiteColor()
  }

}
