//
//  SearchTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import CoreLocation
import BubbleTransition
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class RegionTableViewCell: UITableViewCell {

  @IBOutlet weak var backgroundImageView: UIImageView?
  @IBOutlet weak var locationBackgroundView: UIView?
  @IBOutlet weak var location: UILabel?
  @IBOutlet weak var numRides: UILabel?

  var toRides: [Ride]?
  var fromRides: [Ride]?
  var region: Region?

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    if highlighted {
      backgroundImageView?.alpha = 0.4
      locationBackgroundView?.alpha = 0.5
      location?.textColor = UIColor.white
      numRides?.textColor = UIColor.white
    } else {
      backgroundImageView?.alpha = 0.6
      locationBackgroundView?.alpha = 0.65
      location?.textColor = UIColor.white
      numRides?.textColor = UIColor.white
    }
  }

}

class RegionTableViewController: TableViewController {

  let transition = BubbleTransition()
  let rideService = RideService()

  var user: User?
  var allRides: [Ride]?
  var toRegionToRides: [Region: [Ride]]?
  var fromRegionToRides: [Region: [Ride]]?
  var searchButton: UIButton?
  var expectedRides = -1 {
    didSet {
      if expectedRides == 0 {
        self.tableView?.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }
    addSearchButton()

    tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
    tableView?.dataSource = self

    let token = FIRInstanceID.instanceID().token()!
    print("InstanceID token: \(token)")

    // pull to refresh
    rideService.delegate = self
    if #available(iOS 10.0, *) {
      self.tableView?.refreshControl = UIRefreshControl()
      self.tableView?.refreshControl?.backgroundColor = Color.Green
      self.tableView?.refreshControl?.addTarget(self, action: #selector(reloadData), for: UIControlEvents.valueChanged)
    } else {
      // Fallback on earlier versions
    }
  }

  func reloadData() {
    // End the refreshing
    if #available(iOS 10.0, *) {
      // Reload table data from scratch
      allRides = []
      toRegionToRides = [Region: [Ride]]()
      fromRegionToRides = [Region: [Ride]]()
      for region in Region.allRegions {
        toRegionToRides?[region] = [Ride]()
        fromRegionToRides?[region] = [Ride]()
      }

      rideService.getAllRides()

      if (self.tableView?.refreshControl != nil) {
        self.tableView?.refreshControl?.endRefreshing()
      }
    } else {
      // Fallback on earlier versions
    }
  }


  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(true, animated: true)
    super.viewWillAppear(animated)
  }

  func actionHandler(_: UIAlertAction!) -> Void {
    self.performSegue(withIdentifier: "unwindToMainSegue", sender: self)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toRegionRides" {
      if let vc = segue.destination as? RegionRidesViewController {
        if let cell = sender as? RegionTableViewCell {
          vc.user = user
          vc.toRides = cell.toRides
          vc.fromRides = cell.fromRides
          vc.region = cell.region
        }
      }
    } else if segue.identifier == "toSearch" {
      if let vc = segue.destination as? UINavigationController {
        if let svc = vc.viewControllers.first as? SearchViewController {
          svc.allRides = allRides
          svc.user = user
        }
      }
    }

    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
  }

  func addSearchButton() {
    let borderWidth: CGFloat = 4
    searchButton = UIButton(type: .custom)
    if let searchButton = searchButton {
      searchButton.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
      searchButton.frame = searchButton.frame.insetBy(dx: -borderWidth, dy: -borderWidth)
      searchButton.center = CGPoint(x: view.frame.midX, y: view.frame.maxY - 32)
      searchButton.layer.cornerRadius = searchButton.frame.width / 2
      searchButton.layer.borderColor = UIColor.white.cgColor
      searchButton.layer.borderWidth = borderWidth
      searchButton.setImage(UIImage(named:"search_circle"), for: .normal)
      searchButton.contentMode = .scaleAspectFit
      searchButton.addTarget(self, action: #selector(onSearchButtonPressed), for: .touchUpInside)
      tabBarController?.view.addSubview(searchButton)
    }
  }

  func onSearchButtonPressed() {
    performSegue(withIdentifier: "toSearch", sender: self)
  }

}

// MARK: UITableViewDataSource
extension RegionTableViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Region.allRegions.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let region = Region.allRegions[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath as IndexPath)

    if let regionCell = cell as? RegionTableViewCell {
      regionCell.region = region
      regionCell.backgroundImageView?.image = region.image()
      regionCell.location?.text = region.name()
      var count = 0
      if let toRides = toRegionToRides?[region] {
        regionCell.toRides = toRides
        count += toRides.count
      }
      if let fromRides = fromRegionToRides?[region] {
        regionCell.fromRides = fromRides
        count += fromRides.count
      }
      regionCell.numRides?.text = "\(count) rides"
    }

    return cell
  }

  private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
  }

}

extension RegionTableViewController: FirebaseRidesDelegate {
  func onRideReceived(ride: Ride) {
    if let driverId = ride.driver?.id {
      if let userId = user?.id {
        if driverId != userId {
          allRides?.append(ride)
          if let toLocationCity = ride.toLocation?.city {
            let region = Region.getRegion(city: toLocationCity)
            toRegionToRides?[region]?.append(ride)
          }
          if let fromLocationCity = ride.fromLocation?.city {
            let region = Region.getRegion(city: fromLocationCity)
            fromRegionToRides?[region]?.append(ride)
          }
        }
      }
    }

    expectedRides -= 1
  }

  func onNumRidesReceived(numRides: Int) {
    expectedRides = numRides
  }

  func onSavedRidesReceived(rides: [Ride]) {
    // Do nothing since we are loading all rides.
  }

  func onRideAdded(ride: Ride) {
//    if allRides?.index(of: ride) == nil {
//      allRides?.append(ride)
//      if let toLocationCity = ride.toLocation?.city {
//        let region = Region.getRegion(city: toLocationCity)
//        toRegionToRides?[region]?.append(ride)
//      }
//      if let fromLocationCity = ride.fromLocation?.city {
//        let region = Region.getRegion(city: fromLocationCity)
//        fromRegionToRides?[region]?.append(ride)
//      }
//
//    }
  }

  func onRideRemoved(ride: Ride) {
//    if let index = allRides?.index(of: ride) {
//      allRides?.remove(at: index)
//    }
//    if let toLocationCity = ride.toLocation?.city {
//      let region = Region.getRegion(city: toLocationCity)
//      if let index = toRegionToRides?[region]?.index(of: ride) {
//        toRegionToRides?[region]?.remove(at: index)
//      }
//    }
//    if let fromLocationCity = ride.fromLocation?.city {
//      let region = Region.getRegion(city: fromLocationCity)
//      if let index = fromRegionToRides?[region]?.index(of: ride) {
//        fromRegionToRides?[region]?.remove(at: index)
//      }
//    }
  }

}

// MARK: UIViewControllerTransitioningDelegate
extension RegionTableViewController: UIViewControllerTransitioningDelegate {

  func animationControllerForPresentedController(presented: UIViewController,
                                                 presentingController presenting: UIViewController,
                                                 sourceController source: UIViewController)
                                                 -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    if let searchButton = searchButton {
      transition.startingPoint = searchButton.center
    }
    transition.bubbleColor = UIColor.white
    return transition
  }

  func animationControllerForDismissedController(dismissed: UIViewController)
                                                 -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
      if let searchButton = searchButton {
        transition.startingPoint = searchButton.center
      }
    transition.bubbleColor = Color.Green
    return transition
  }

}
