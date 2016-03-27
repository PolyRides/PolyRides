//
//  LoadingViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//


class LoadingViewController: UIViewController {

  let rideService = RideService()
  let userService = UserService()

  var onLoadingComplete: (Void -> Void)?
  var toRegionToRides = [Region: [Ride]]()
  var fromRegionToRides = [Region: [Ride]]()
  var user: User?
  var expectedRides = -1 {
    didSet {
      if expectedRides == 0 {
        startMain()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    for region in Region.allRegions {
      toRegionToRides[region] = [Ride]()
      fromRegionToRides[region] = [Ride]()
    }

    rideService.delegate = self
    userService.delegate = self
  }

  func startLoadingData(onLoadingComplete: (Void -> Void)? = nil) {
    self.onLoadingComplete = onLoadingComplete
    if let user = user {
      userService.updateValuesForUser(user)
    }
  }

  func startMain() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateInitialViewController()
    if let tabBarVC = viewController as? TabBarController {
      tabBarVC.user = user

      if let navVC = tabBarVC.viewControllers?.first as? UINavigationController {
        if let searchVC = navVC.topViewController as? RegionTableViewController {
          searchVC.fromRegionToRides = fromRegionToRides
          searchVC.toRegionToRides = toRegionToRides
        }
      }
      if let delegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
        delegate.window?.rootViewController = tabBarVC
      }

      onLoadingComplete?()
    }
  }
}

// MARK: - FirebaseRidesDelegate
extension LoadingViewController: FirebaseRidesDelegate {

  func onRideReceived(ride: Ride) {
    if let driverId = ride.driver?.id {
      if let userId = user?.id {
        if driverId != userId {
          if let toLocationCity = ride.toLocation?.city {
            let region = Region.getRegion(toLocationCity)
            toRegionToRides[region]?.append(ride)
          }
          if let fromLocationCity = ride.fromLocation?.city {
            let region = Region.getRegion(fromLocationCity)
            fromRegionToRides[region]?.append(ride)
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

}

// MARK: - FirebaseUserDelegate
extension LoadingViewController: FirebaseUserDelegate {

  func onUserUpdated() {
    rideService.getAllRides()
  }

}
