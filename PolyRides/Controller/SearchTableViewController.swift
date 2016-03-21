//
//  SearchTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import CoreLocation

class RegionTableViewCell: UITableViewCell {

  @IBOutlet weak var backgroundImageView: UIImageView?
  @IBOutlet weak var location: UILabel?
  @IBOutlet weak var numRides: UILabel?

  var rides: [Ride]?

}

class SearchTableViewController: UITableViewController {

 // var user: User?
  var regionToRides = [Region: [Ride]]()


  override func viewDidLoad() {
    super.viewDidLoad()

    for region in Region.allRegions {
      regionToRides[region] = [Ride]()
    }

    FirebaseConnection.service.allRidesDelegate = self
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

  }

}


// MARK: - UITableViewDataSource
extension SearchTableViewController {

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return regionToRides.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let region = Region.allRegions[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("regionCell", forIndexPath: indexPath)

    if let regionCell = cell as? RegionTableViewCell {
      regionCell.backgroundImageView?.image = region.image()
      regionCell.location?.text = region.name()
      if let rides = regionToRides[region] {
        regionCell.rides = rides
        regionCell.numRides?.text = "\(rides.count) rides"
      } else {
        regionCell.numRides?.text = "0 rides"
      }
    }

    return cell
  }

}

// MARK: - FirebaseRidesDelegate
extension SearchTableViewController: FirebaseAllRidesDelegate {

  func onRidesReceived(rides: [Ride]) {
    // sort into various regions
    for ride in rides {
      if let toLocationCity = ride.toLocation?.city {
        let region = Region.getRegion(toLocationCity)
        regionToRides[region]?.append(ride)
      }
      if let fromLocationCity = ride.fromLocation?.city {
        let region = Region.getRegion(fromLocationCity)
        regionToRides[region]?.append(ride)
      }
    }

    tableView.reloadData()
  }

}
