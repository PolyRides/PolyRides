//
//  RidesTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class RideTableViewCell: UITableViewCell {

  var ride: Ride?

}

class RidesTableViewController: TableViewController {

  var rides: [Ride]? {
    didSet {
      tableView?.reloadData()
    }
  }
  var user: User?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.dataSource = self
  }

}

// MARK: - UITableViewDataSource
extension RidesTableViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let rides = rides {
      return rides.count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath)

    if let ride = rides?[indexPath.row] {
      if let rideCell = cell as? RideTableViewCell {
        rideCell.textLabel?.text = ride.getFormattedLocation()
        rideCell.detailTextLabel?.text = ride.getFormattedDate()

        rideCell.ride = ride
      }
    }

    return cell
  }

}
