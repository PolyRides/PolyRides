//
//  LoadingViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FirebaseInstanceID

class LoadingViewController: UIViewController {

  let rideService = RideService()
  let userService = UserService()

  var onLoadingComplete: ((Void) -> Void)?
  var allRides = [Ride]()
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

  func startLoadingData(onLoadingComplete: ((Void) -> Void)? = nil) {
    self.onLoadingComplete = onLoadingComplete
    if let user = user {
      userService.updateValuesForUser(user: user)
      // update database with user's token
      userService.setUserInstanceIDToken(user: user)
      user.instanceID = FIRInstanceID.instanceID().token()
    }
  }

  func startMain() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateInitialViewController()
    if let tabBarVC = viewController as? TabBarController {
      tabBarVC.user = user

      if let navVC = tabBarVC.viewControllers?.first as? UINavigationController {
        if let vc = navVC.topViewController as? RegionTableViewController {
          vc.allRides = allRides
          vc.fromRegionToRides = fromRegionToRides
          vc.toRegionToRides = toRegionToRides
        }
      }
      if let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
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
          allRides.append(ride)
          if let toLocationCity = ride.toLocation?.city {
            let region = Region.getRegion(city: toLocationCity)
            toRegionToRides[region]?.append(ride)
          }
          if let fromLocationCity = ride.fromLocation?.city {
            let region = Region.getRegion(city: fromLocationCity)
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

  func onRideAdded(ride: Ride) {
    if allRides.index(of: ride) == nil {
      allRides.append(ride)
      if let toLocationCity = ride.toLocation?.city {
        let region = Region.getRegion(city: toLocationCity)
        toRegionToRides[region]?.append(ride)
      }
      if let fromLocationCity = ride.fromLocation?.city {
        let region = Region.getRegion(city: fromLocationCity)
        fromRegionToRides[region]?.append(ride)
      }

    }
  }

  func onRideRemoved(ride: Ride) {
    if let index = allRides.index(of: ride) {
      allRides.remove(at: index)
    }
    if let toLocationCity = ride.toLocation?.city {
      let region = Region.getRegion(city: toLocationCity)
      if let index = toRegionToRides[region]?.index(of: ride) {
        toRegionToRides[region]?.remove(at: index)
      }
    }
    if let fromLocationCity = ride.fromLocation?.city {
      let region = Region.getRegion(city: fromLocationCity)
      if let index = fromRegionToRides[region]?.index(of: ride) {
        fromRegionToRides[region]?.remove(at: index)
      }
    }
  }

}

// MARK: - FirebaseUserDelegate
extension LoadingViewController: FirebaseUserDelegate {

  func onUserUpdated() {
    rideService.getAllRides()
  }

  func onUserIdReceived() {
    startLoadingData()
  }

}
