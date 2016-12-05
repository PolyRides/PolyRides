//
//  RegionRidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import DZNEmptyDataSet

class RegionRidesViewController: RidesTableViewController {

  var region: Region?
  var toRides: [Ride]?
  var fromRides: [Ride]?

  @IBOutlet weak var segmentedControl: UISegmentedControl?

  @IBAction func segmentedControlAction(sender: AnyObject) {
    if let segmentedControl = sender as? UISegmentedControl {
      if segmentedControl.selectedSegmentIndex == 0 {
        rides = fromRides
        if let region = region {
          emptyMessage = Empty.FromRegion(region: region)
        }
      } else {
        rides = toRides
        if let region = region {
          emptyMessage = Empty.ToRegion(region: region)
        }
      }
    }
    tableView?.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    rides = fromRides
    title = region?.name()

    emptyImage = "empty"
    emptyTitle = Empty.RegionTitle
    if let region = region {
      emptyMessage = Empty.FromRegion(region: region)
    }
    tableView?.delegate = self
    tableView?.reloadData()
    segmentedControl?.setTitleTextAttributes(Attributes.SegmentedControl, for: .normal)
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: true)
    super.viewWillAppear(animated)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPassengerRideDetails" {
      if let vc = segue.destination as? RideDetailsViewController {
        if let cell = sender as? RideTableViewCell {
          vc.ride = cell.ride
          vc.user = user
        }
      }
    } else if segue.identifier == "toRideSearch" {
      if let vc = segue.destination as? SearchViewController {
        vc.user = user
      }
    }
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
  }

}

// MARK: - UITableViewDelegate
extension RegionRidesViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
  }

}
