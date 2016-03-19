//
//  AddRideViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/17/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class AddRideViewController: UIViewController {

  let gpaKey = "AIzaSyBV7uveXT1JXkp149zLJgmCb2U-caWuH84"

  var user: User?
  var gpaVC: UINavigationController?
  var autocompleteVC: AutocompleteViewController?
  var toLocationPlace: Place?
  var fromLocationPlace: Place?

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
    // Send ride to Firebase.
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func stepperValChanged(sender : UIStepper) {
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

    setupAutocomplete()
  }

  func setupAutocomplete() {
    let id = "Autocomplete"
    let storyboard = UIStoryboard(name: id, bundle: nil)
    if let navVC = storyboard.instantiateViewControllerWithIdentifier(id) as? UINavigationController {
      gpaVC = navVC
      autocompleteVC = navVC.topViewController as? AutocompleteViewController
      autocompleteVC?.delegate = self
    }
  }

  func setEnableAddButton() {
    if toLocationPlace != nil && fromLocationPlace != nil && costTextField?.text != nil {
      addButton?.enabled = true
    }
  }

}

// MARK: - GooglePlacesAutocompleteDelegate
extension AddRideViewController: AutocompleteDelegate {

  func placesFound(places: [Place]) {
    print("places found")
  }

  func placeSelected(place: Place, sender: AnyObject) {
    print("place selected")
    setEnableAddButton()
  }

  func placeViewClosed() {
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }

}

// MARK: - UITextFieldDelegate
extension AddRideViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    let title = textField == toTextField ? "To Location" : "From Location"
    if let gpaVC = gpaVC {
      if let autocompleteVC = autocompleteVC {
        autocompleteVC.navigationItem.title = title
        autocompleteVC.sender = textField
        navigationController?.presentViewController(gpaVC, animated: true, completion: nil)
      }
    }

    return false
  }

}

// MARK: - UITextViewDelegate
extension AddRideViewController: UITextViewDelegate {

  func textViewDidBeginEditing(textView: UITextView) {
    if notesTextView?.textColor == UIColor.lightGrayColor() {
      notesTextView?.text = nil
      notesTextView?.textColor = UIColor.blackColor()
    }
  }

  func textViewDidEndEditing(textView: UITextView) {
    if let notesTextView = notesTextView {
      if notesTextView.text.isEmpty {
        notesTextView.text = "Optional notes for passengers"
        notesTextView.textColor = UIColor.lightGrayColor()
      }
    }
  }
  
}
