//
//  SearchViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/27/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps

class SearchViewController: UIViewController {

  @IBOutlet weak var fromPlaceTextField: UITextField?
  @IBOutlet weak var toPlaceTextField: UITextField?
  @IBOutlet weak var dateTextField: UITextField?

  var autocompleteTextField: UITextField?
  var datePicker: UIDatePicker?
  var dateFormatter: NSDateFormatter?
  var fromPlace: GMSPlace?
  var toPlace: GMSPlace?

  override func viewDidLoad() {
    super.viewDidLoad()

    fromPlaceTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.size.width - 64, height: 28))
    fromPlaceTextField?.backgroundColor = UIColor.lightGrayColor()
    fromPlaceTextField?.placeholder = "From"
    navigationItem.titleView = fromPlaceTextField

    fromPlaceTextField?.delegate = self
    toPlaceTextField?.delegate = self

    dateFormatter = NSDateFormatter()
    dateFormatter?.dateStyle = .MediumStyle
    dateFormatter?.timeStyle = .ShortStyle

    datePicker = UIDatePicker()
    datePicker?.minuteInterval = 15

    let toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.Default
    toolBar.translucent = true
    toolBar.sizeToFit()

    let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(onDone))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(onCancel))

    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.userInteractionEnabled = true

    dateTextField?.inputView = datePicker
    dateTextField?.inputAccessoryView = toolBar
    dateTextField?.text = dateFormatter?.stringFromDate(DateHelper.nearestHalfHour())
  }

  func onCancel() {
    dateTextField?.resignFirstResponder()
  }

  func onDone() {
    if let datePicker = datePicker {
      dateTextField?.text = dateFormatter?.stringFromDate(datePicker.date)
    }
    dateTextField?.resignFirstResponder()
  }

}

// MARK: - GMSAutocompleteViewControllerDelegate
extension SearchViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
    autocompleteTextField?.text = place.formattedAddress

    if autocompleteTextField == toPlaceTextField {
      toPlace = place
    } else {
      fromPlace = place
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
extension SearchViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    autocompleteTextField = textField

    let filter = GMSAutocompleteFilter()
    filter.country = "US"

    // Set the bounds to have bias around California.
    let topLeft = CLLocationCoordinate2DMake(41.975926, -124.509506)
    let bottomRight = CLLocationCoordinate2DMake(32.974171, -113.799198)
    let bounds = GMSCoordinateBounds(coordinate: topLeft, coordinate: bottomRight)

    let autocompleteController = GMSAutocompleteViewController()
    // autocompleteController.
    autocompleteController.autocompleteFilter = filter
    autocompleteController.autocompleteBounds = bounds
    autocompleteController.delegate = self
    self.presentViewController(autocompleteController, animated: true, completion: nil)

    return false
  }

}
