//
//  AddRideViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/17/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Eureka
import GooglePlacesAutocomplete

class AddRideViewController: FormViewController {

  var user: User?

  @IBAction func cancelButtonAction(sender: AnyObject) {
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func addButtonAction(sender: AnyObject) {
    // Send ride to Firebase.
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initializeForm()
  }

  private func initializeForm() {
    form
      +++ Section("Ride Details")
      <<< TextRow() {
        $0.title = "To"
      }
      <<< TextRow() {
        $0.title = "From"
      }
      <<< DateTimeInlineRow("Date") {
        $0.value = DateHelper.nearestHalfHour()
        $0.title = $0.tag
        $0.minuteInterval = 15

      }

      +++ Section("Additional information")
//      <<< StepperRow() {
//        $0.title = "Number of seats"
//        $0.value = 1.0
//      }
      <<< TextRow() {
        $0.title = "Cost per seat"
        $0.placeholder = "$"
      }

      +++ Section("Notes")
      <<< TextAreaRow() {
        $0.placeholder = "Optional notes for passengers"
      }
  }

  func showAutocomplete() {
    let key = "AIzaSyBV7uveXT1JXkp149zLJgmCb2U-caWuH84"
    let gpaVC = GooglePlacesAutocomplete(apiKey: key, placeType: .Address)
    gpaVC.placeDelegate = self
    gpaVC.navigationItem.title = "Location"
    gpaVC.navigationItem.leftBarButtonItem = nil
    let cancel = UIBarButtonItem(barButtonSystemItem: .Cancel, target: gpaVC, action: "close")
    gpaVC.navigationItem.rightBarButtonItem = cancel
    presentViewController(gpaVC, animated: true, completion: nil)
  }

}

// MARK: - GooglePlacesAutocompleteDelegate
extension AddRideViewController: GooglePlacesAutocompleteDelegate {

  func placesFound(places: [Place]) {
    print("places found")
  }

  func placeSelected(place: Place) {
    print("place selected")
  }

  func placeViewClosed() {
    print("place view closed")
  }

}
