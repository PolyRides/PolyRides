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
  var segmentedControl: UISegmentedControl?

  @IBOutlet weak var locationLabel: UILabel?
  @IBOutlet weak var dateLabel: UILabel?
  @IBOutlet weak var seatsAvailableLabel: UILabel?
  @IBOutlet weak var costPerSeatLabel: UILabel?
  @IBOutlet weak var descriptionTextView: UITextView?
  @IBOutlet weak var acceptedPassengers: UITextView?
  @IBOutlet weak var removeRideButton: UIButton?

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

      if acceptedPassengers != nil {
        if ride.passengers.count != 0 {
          for pass in ride.passengers.values {
            acceptedPassengers!.text = "\(acceptedPassengers!.text!)\(pass)\n"
          }
        } else {
          acceptedPassengers!.attributedText = NSAttributedString(string: "You have no passengers in this ride.",
                                                                  attributes: [NSFontAttributeName: UIFont.italicSystemFont(ofSize: (CGFloat(UIFont.systemFontSize)))])
        }

        // can only leave / remove a current ride
        if segmentedControl?.selectedSegmentIndex == 0 {
          if ride.driver?.id != user?.id {
            removeRideButton?.setTitle("Leave Ride", for: .normal)
          } else {
            removeRideButton?.setTitle("Remove Ride", for: .normal)
          }
        } else {
          removeRideButton?.isHidden = true
        }
      }
    }
  }

}
