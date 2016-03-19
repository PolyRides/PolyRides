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

  var user: User?
  var toLocationPlace: GMSPlace?
  var fromLocationPlace: GMSPlace?
  var autocompleteTextField: UITextField?

  @IBOutlet weak var toTextField: UITextField?
  @IBOutlet weak var fromTextField: UITextField?
  @IBOutlet weak var datePicker: UIDatePicker?
  @IBOutlet weak var seatsLabel: UILabel?
  @IBOutlet weak var costTextField: UITextField?
  @IBOutlet weak var notesTextView: UITextView?
  @IBOutlet weak var addButton: UIBarButtonItem?

  @IBAction func cancelButtonAction(sender: AnyObject) {
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func addButtonAction(sender: AnyObject) {
    if var cost = costTextField?.text {
      if let description = notesTextView?.text {
        if let seats = seatsLabel?.text {
          if let date = datePicker?.date {
            cost = cost.stringByReplacingOccurrencesOfString("$", withString: "")
            if let user = user {
              let ride = Ride(driver: user, date: date, seats: Int(seats), description: description, cost: Int(cost))
              ride.fromLocation = locationFromPlace(fromLocationPlace)
              ride.toLocation = locationFromPlace(toLocationPlace)
              FirebaseConnection.pushRideToFirebase(ride)
            }
          }
        }
      }
    }
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func stepperValChanged(sender: UIStepper) {
      seatsLabel?.text = Int(sender.value).description
  }

  @IBAction func costEditingChanged(sender: AnyObject) {
    if let currentValue = costTextField?.text {
      let strippedValue = currentValue.stringByReplacingOccurrencesOfString("[^0-9]",
        withString: "", options: .RegularExpressionSearch)
      var formattedString = ""

      if strippedValue.characters.count > 0 {
        formattedString = "$" + (strippedValue as String)
      }
      costTextField?.text = formattedString
      setEnableAddButton()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    toTextField?.delegate = self
    fromTextField?.delegate = self

  }

  func setEnableAddButton() {
    if toLocationPlace != nil && fromLocationPlace != nil && costTextField?.text != nil {
      addButton?.enabled = true
    }
  }

  func locationFromPlace(place: GMSPlace?) -> Location? {
    if let place = place {
      if let city = place.addressComponents?.city {
        return Location(place: place, city: city)
      }
    }
    return nil
  }

}

// MARK: - GMSAutocompleteViewControllerDelegate
extension AddRideViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(viewController: GMSAutocompleteViewController,
    didAutocompleteWithPlace place: GMSPlace) {
    autocompleteTextField?.text = place.formattedAddress

    if autocompleteTextField == toTextField {
      toLocationPlace = place
    } else {
      fromLocationPlace = place
    }

    dismissViewControllerAnimated(true, completion: nil)
  }

  func viewController(viewController: GMSAutocompleteViewController,
    didFailAutocompleteWithError error: NSError) {
    let title = "Please check your connection and try again."
    presentAlert(AlertOptions(message: "Network Error", title: title))
    dismissViewControllerAnimated(true, completion: nil)
  }

  func wasCancelled(viewController: GMSAutocompleteViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }

}

// MARK: - UITextFieldDelegate
extension AddRideViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    autocompleteTextField = textField

    let filter = GMSAutocompleteFilter()
    filter.country = "US"

    // Set the bounds to have bias around California.
    let topLeft = CLLocationCoordinate2DMake(41.975926, -124.509506)
    let bottomRight = CLLocationCoordinate2DMake(32.974171, -113.799198)
    let bounds = GMSCoordinateBounds(coordinate: topLeft, coordinate: bottomRight)

    let acController = GMSAutocompleteViewController()
    acController.autocompleteFilter = filter
    acController.autocompleteBounds = bounds
    acController.delegate = self
    self.presentViewController(acController, animated: true, completion: nil)

    return false
  }

}
