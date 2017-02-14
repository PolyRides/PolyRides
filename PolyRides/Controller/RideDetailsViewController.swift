//
//  RideDetailsViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class RideDetailsViewController: UIViewController {

  var ride: Ride?
  var user: User?

  @IBOutlet weak var locationLabel: UILabel?
  @IBOutlet weak var dateLabel: UILabel?
  @IBOutlet weak var seatsAvailableLabel: UILabel?
  @IBOutlet weak var costPerSeatLabel: UILabel?
  @IBOutlet weak var descriptionTextView: UITextView?
  @IBOutlet weak var acceptedPassengers: UITextView?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let ride = ride {
      locationLabel?.text = ride.getFormattedLocation()
      dateLabel?.text = ride.getFormattedDate()
      if let seatsAvailable = ride.seatsAvailable {
        seatsAvailableLabel?.text = "Seats: \(seatsAvailable)"
      }
      if let costPerSeat = ride.costPerSeat {
        costPerSeatLabel?.text = "Cost per seat: \(costPerSeat)"
      }
      descriptionTextView?.text = ride.description
      if ride.passengers.count != 0 {
        for pass in ride.passengers {
          acceptedPassengers?.text = "\(acceptedPassengers!.text)\(pass)\n"
        }
      } else {
        acceptedPassengers?.text = ""
      }

    }
  }

}
