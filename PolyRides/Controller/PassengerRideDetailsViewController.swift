//
//  PassengerRideDetailsViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class DriverTableViewCell: UITableViewCell {

  var driver: User?

  @IBOutlet weak var driverImageView: UIImageView?
  @IBOutlet weak var name: UILabel?

}

class PassengerRideDetailsViewController: RideDetailsViewController {

  @IBOutlet weak var tableView: UITableView?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.dataSource = self
  }

}

// MARK: - UITableViewDataSource
extension PassengerRideDetailsViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("driverCell", forIndexPath: indexPath)

    if let driverCell = cell as? DriverTableViewCell {
      driverCell.driver = ride?.driver
      driverCell.name?.text = ride?.driver?.getFullName()
    }

    return cell
  }

}
