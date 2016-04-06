//
//  RegionRidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import DZNEmptyDataSet

class RegionRidesViewController: RidesViewController {

  var region: Region?
  var toRides: [Ride]?
  var fromRides: [Ride]?

  @IBOutlet weak var segmentedControl: UISegmentedControl?

  @IBAction func segmentedControlAction(sender: AnyObject) {
    if let segmentedControl = sender as? UISegmentedControl {
      if segmentedControl.selectedSegmentIndex == 0 {
        rides = fromRides
        if let region = region {
          emptyMessage = Empty.FromRegion(region)
        }
      } else {
        rides = toRides
        if let region = region {
          emptyMessage = Empty.ToRegion(region)
        }
      }
    }
    tableView?.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    rides = fromRides
    tableView?.reloadData()
    title = region?.name()

    emptyImage = "empty"
    emptyTitle = Empty.RegionTitle
    if let region = region {
      emptyMessage = Empty.FromRegion(region)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toPassengerRideDetails" {
      if let vc = segue.destinationViewController as? RideDetailsViewController {
        if let cell = sender as? RideTableViewCell {
          vc.ride = cell.ride
          vc.user = user
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
