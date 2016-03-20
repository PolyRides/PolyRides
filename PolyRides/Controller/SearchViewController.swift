//
//  SearchTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import CoreLocation

class SearchViewController: UIViewController {

  let locationManager = CLLocationManager()

  var user: User?

  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager.requestWhenInUseAuthorization()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toLogOut" {
      FirebaseConnection.service.ref.unauth()
    }
  }

}
