//
//  AddRideViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/17/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps

class AddRideViewController: UIViewController {

  let gpaKey = "AIzaSyBV7uveXT1JXkp149zLJgmCb2U-caWuH84"
  let rideService = RideService()

  var user: User?
  var ride: Ride?
  var toPlace: GMSPlace?
  var fromPlace: GMSPlace?
  var autocompleteTextField: UITextField?
  var placesClient: GMSPlacesClient?

  @IBOutlet weak var toPlaceTextField: UITextField?
  @IBOutlet weak var fromPlaceTextField: UITextField?
  @IBOutlet weak var datePicker: UIDatePicker?
  @IBOutlet weak var seatsLabel: UILabel?
  @IBOutlet weak var costTextField: UITextField?
  @IBOutlet weak var notesTextView: UITextView?
  @IBOutlet weak var addButton: UIBarButtonItem?

  @IBAction func switchToFromAction(sender: AnyObject) {
    let tempPlace = toPlace
    let tempText = toPlaceTextField?.text
    toPlace = fromPlace
    toPlaceTextField?.text = fromPlaceTextField?.text
    fromPlace = tempPlace
    fromPlaceTextField?.text = tempText
  }

  @IBAction func cancelButtonAction(sender: AnyObject) {
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func stepperValChanged(sender: UIStepper) {
      seatsLabel?.text = Int(sender.value).description
  }

  @IBAction func costEditingChanged(sender: AnyObject) {
    if let currentValue = costTextField?.text {
      let strippedValue = currentValue.stringByReplacingOccurrencesOfString("[^0-9]", withString: "",
        options: .RegularExpressionSearch)
      var formattedString = ""

      if strippedValue.characters.count > 0 {
        formattedString = "$\(strippedValue)"
      }
      costTextField?.text = formattedString
      setEnableAddButton()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()




    toPlaceTextField?.delegate = self
    fromPlaceTextField?.delegate = self

    placesClient = GMSPlacesClient()
    setupAppearance()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "addRide" {
      if var cost = costTextField?.text {
        if var description = notesTextView?.text {
          if let seats = seatsLabel?.text {
            if let date = datePicker?.date {
              cost = cost.stringByReplacingOccurrencesOfString("$", withString: "")
              if let user = user {
                if description == "Optional notes for passengers" {
                  description = ""
                }

              let ride = Ride(driver: user, date: date, seats: Int(seats), description: description, cost: Int(cost))
                ride.fromLocation = locationFromPlace(fromPlace)
                ride.toLocation = locationFromPlace(toPlace)
                ride.timestamp = NSDate()
                rideService.pushRideToFirebase(ride)
                self.ride = ride
              }
            }
          }
        }
      }
    } else if segue.identifier == "toAutocomplete" {
      if let navVC = segue.destinationViewController as? UINavigationController {
        if let vc = navVC.topViewController as? AutocompleteViewController, let textField = sender as? UITextField {
          vc.delegate = self
          vc.initialText = textField.text
          vc.user = user
        }
      }
    }
  }

  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
    if identifier == "addRide" {
      if let date = datePicker?.date {
        if date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
          let title = "Invalid Depature Date"
          let message = "Rides in the past cannot be posted. Please adjust your departure date."
          presentAlert(AlertOptions(message: message, title: title))

          return false
        }
      }
    }
    return true
  }

  func setEnableAddButton() {
    if toPlace != nil && fromPlace != nil && costTextField?.text != nil {
      addButton?.enabled = true
    }
  }

  func locationFromPlace(place: GMSPlace?) -> Location? {
    if let place = place {
      if let city = place.addressComponents?.city {
        return Location(place: place, city: city)
      } else {
        return Location(place: place, city: place.name)
      }
    }
    return nil
  }

}

// MARK: - AutocompleteDelegate
extension AddRideViewController: AutocompleteDelegate {

  func onPlaceSelected(place: GMSPlace?) {
    autocompleteTextField?.text = place?.formattedAddress
    if autocompleteTextField == toPlaceTextField {
      toPlace = place
    } else {
      fromPlace = place
    }
  }

}

// MARK: - UITextFieldDelegate
extension AddRideViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    autocompleteTextField = textField
    performSegueWithIdentifier("toAutocomplete", sender: textField)
    return false
  }

}
