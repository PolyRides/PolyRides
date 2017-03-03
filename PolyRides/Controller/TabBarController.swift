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

    let border = UIView()
    border.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
    border.center = CGPoint(x: view.frame.midX, y: view.frame.maxY - 32)
    border.layer.cornerRadius = border.frame.width / 2
    border.backgroundColor = Color.Green
    view.addSubview(border)
    view.bringSubview(toFront: tabBar)

    viewControllers?.forEach {
      if let vc = $0 as? UINavigationController {
        _ = vc.topViewController?.view
      }
    }

    locationManager.requestWhenInUseAuthorization()
    GoogleMapsHelper.PlacesClient.currentPlace(callback: { placeLikelihoods, error -> Void in
      if let placeLikelihood = placeLikelihoods?.likelihoods.first {
        self.user?.currentLocation = placeLikelihood.place
      }
    })
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.isNavigationBarHidden = false
  }



}
