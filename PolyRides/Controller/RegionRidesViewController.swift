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

    rides = toRides
  }

  @IBAction func segmentedControlAction(sender: AnyObject) {
    if let segmentedControl = sender as? UISegmentedControl {
      if segmentedControl.selectedSegmentIndex == 0 {
        rides = toRides
      } else {
        rides = fromRides
      }
    }
    tableView?.reloadData()
  }

}
