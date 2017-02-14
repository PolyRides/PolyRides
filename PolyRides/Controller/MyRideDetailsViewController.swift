//
//  MyRideDetailsViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/23/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class MyRideDetailsViewController: RideDetailsViewController {

  // this will have the list of accepted and pending passengers

  @IBAction func removeRideAction(sender: AnyObject) {
    // Handle deleting a ride
    RideService().removeRide(ride: ride!)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

}
