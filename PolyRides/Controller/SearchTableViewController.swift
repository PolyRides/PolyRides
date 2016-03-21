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
  var region: Region?

}

class SearchTableViewController: UITableViewController {

  var user: User?
  var regionToRides = [Region: [Ride]]()

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }

    for region in Region.allRegions {
      regionToRides[region] = [Ride]()
    }
    FirebaseConnection.service.allRidesDelegate = self

    let searchBar = UISearchBar()
    searchBar.sizeToFit()
    searchBar.delegate = self
    navigationItem.titleView = searchBar

    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toRegionRides" {
      if let vc = segue.destinationViewController as? RegionRidesViewController {
        if let cell = sender as? RegionTableViewCell {
          vc.rides = cell.rides
          vc.title = cell.region?.name()
        }
      }
    }
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
      regionCell.region = region
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
    for ride in rides {
      if let driverId = ride.driver?.id {
        if let userId = user?.id {
          if driverId != userId {
            if let toLocationCity = ride.toLocation?.city {
              let region = Region.getRegion(toLocationCity)
              regionToRides[region]?.append(ride)
            }
            if let fromLocationCity = ride.fromLocation?.city {
              let region = Region.getRegion(fromLocationCity)
              regionToRides[region]?.append(ride)
            }
          }
        }
      }
    }

    tableView.reloadData()
  }

}

// MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {

  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    // segue to search page
    return false
  }

}
