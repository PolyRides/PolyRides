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
  var currentRides = [Ride]()
  var pastRides = [Ride]()
  var savedRides = [Ride]()
  var expectedRides = -1 {
    didSet {
      if expectedRides == 0 {
        // Set empty data set delegates
        tableView?.reloadData()
      }
    }
  }

  @IBOutlet weak var tableView: UITableView?
  @IBOutlet weak var segmentedControl: UISegmentedControl?

  @IBAction func segmentedAction(sender: AnyObject) {
      tableView?.reloadData()
  }

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
    } else if segue.identifier == "toLogin" {
      FirebaseConnection.service.ref.unauth()
    }
  }

}


// MARK: - UITableViewDataSource
extension RidesViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let index = segmentedControl?.selectedSegmentIndex {
      switch index {
      case 0:
        return currentRides.count
      case 1:
        return pastRides.count
      default:
        return savedRides.count
      }
    }
    return 0
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("rideCell", forIndexPath: indexPath)

    var ride: Ride
    if let index = segmentedControl?.selectedSegmentIndex {
      switch index {
      case 0:
        ride = currentRides[indexPath.row]
      case 1:
        ride = pastRides[indexPath.row]
      default:
        ride = savedRides[indexPath.row]
      }


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

// MARK: - FirebaseRidesDelegate
extension RidesViewController: FirebaseRidesDelegate {

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

  func onRideAdded(ride: Ride) {
    if ride.date?.compare(NSDate()) == .OrderedDescending {
      currentRides.append(ride)
    } else {
      pastRides.append(ride)
    }
  }

}
