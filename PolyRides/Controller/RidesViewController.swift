//
//  RidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/16/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class RideTableViewCell: UITableViewCell {

  var ride: Ride?

}

class RidesViewController: UIViewController {

  var user: User?
  var rides = [Ride]()
  var expectedRides = -1 {
    didSet {
      if expectedRides == 0 {
        // Set empty data set delegates
        print(rides.count)
        tableView?.reloadData()
      }
    }
  }

  @IBOutlet weak var tableView: UITableView?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = self.tabBarController as? TabBarController {
      self.user = tabBarController.user
    }

    tableView?.delegate = self
    tableView?.dataSource = self

    FirebaseConnection.service.ridesDelegate = self
    if let user = user {
      FirebaseConnection.service.getRidesForUser(user)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toAddRide" {
      if let navVC = segue.destinationViewController as? UINavigationController {
        if let addRideVC = navVC.topViewController as? AddRideViewController {
          addRideVC.user = user
        }
      }
    }
  }

}


// MARK: - UITableViewDataSource
extension RidesViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rides.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let ride = rides[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("rideCell", forIndexPath: indexPath)
    if let rideCell = cell as? RideTableViewCell {
      if let fromCity = ride.fromLocation?.city {
        if let toCity = ride.toLocation?.city {
          rideCell.textLabel?.text = "\(fromCity) → \(toCity)"

          if let date = ride.date {
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "EEEE, MMM dd"
            let day = timeFormatter.stringFromDate(date)
            timeFormatter.dateFormat = "h:mm a"
            let time = timeFormatter.stringFromDate(date)

            rideCell.detailTextLabel?.text = "\(day) at \(time)"
          }
        }
      }
      rideCell.ride = ride
      return rideCell
    }
    return cell
  }

}

// MARK: - UITableViewDelegate
extension RidesViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print("selected a ride, going to ride details")
  }
}

// MARK: - UITableViewDelegate
extension RidesViewController: FirebaseRidesDelegate {

  func onRideReceived(ride: Ride) {
    rides.append(ride)
    expectedRides -= 1
  }

  func onNumRidesReceived(numRides: Int) {
    expectedRides = numRides
  }
}
