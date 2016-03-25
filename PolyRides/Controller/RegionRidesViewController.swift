//
//  RegionRidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class RegionRidesViewController: RidesViewController {

  var region: Region?
  var toRides: [Ride]?
  var fromRides: [Ride]?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.delegate = self
    rides = fromRides
  }

  @IBAction func segmentedControlAction(sender: AnyObject) {
    if let segmentedControl = sender as? UISegmentedControl {
      if segmentedControl.selectedSegmentIndex == 0 {
        rides = fromRides
      } else {
        rides = toRides
      }
    }
    tableView?.reloadData()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toPassengerRideDetails" {
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

}

// MARK: - UITableViewDelegate
extension RegionRidesViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

}
