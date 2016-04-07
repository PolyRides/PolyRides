//
//  TabBarViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/15/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class TabBarController: UITabBarController {

  let locationManager = CLLocationManager()

  var user: User?

  override func viewDidLoad() {
    super.viewDidLoad()

    viewControllers?.forEach {
      if let vc = $0 as? UINavigationController {
        vc.topViewController?.view
      }
    }

    locationManager.requestWhenInUseAuthorization()
    GoogleMapsHelper.PlacesClient.currentPlaceWithCallback({ placeLikelihoods, error -> Void in
      if let placeLikelihood = placeLikelihoods?.likelihoods.first {
        self.user?.currentLocation = placeLikelihood.place
      }
    })
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBarHidden = false
  }

}
