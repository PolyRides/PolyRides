//
//  SearchViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/27/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GooglePlaces
import GoogleMaps

class SearchViewController: TableViewController {

  @IBOutlet weak var fromPlaceTextField: UITextField?
  @IBOutlet weak var toPlaceTextField: UITextField?
  @IBOutlet weak var dateTextField: UITextField?
  @IBOutlet weak var placeStackView: UIStackView?
  @IBOutlet weak var closeButton: UIButton?

  @IBAction func switchToFromAction(sender: AnyObject) {
    let tempPlace = toPlace
    let tempText = toPlaceTextField?.text
    toPlace = fromPlace
    toPlaceTextField?.text = fromPlaceTextField?.text
    fromPlace = tempPlace
    fromPlaceTextField?.text = tempText
  }

  @IBAction func onCloseButtonAction(sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  let calendar = NSCalendar.current


  var user: User?
  var allRides: [Ride]?
  var rides: [Ride]?
  var autocompleteTextField: UITextField?
  var date: Date?
  var datePicker: UIDatePicker?
  var dateFormatter: DateFormatter?
  var fromPlace: GMSPlace?
  var toPlace: GMSPlace?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.dataSource = self
    fromPlaceTextField?.delegate = self
    toPlaceTextField?.delegate = self
    dateTextField?.delegate = self

    emptyTitle = Empty.BeginSearchTitle
    emptyMessage = Empty.BeginSearchMessage
    emptyImage = "arrow"

    if let closeButton = closeButton {
      closeButton.clipsToBounds = true
      closeButton.layer.cornerRadius = closeButton.layer.frame.size.width / 2
    }
    setupDatePicker()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  func setupTextFields() {
    let fromLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 50, height: fromPlaceTextField!.frame.size.height))
    fromLabel.text = "From"
    fromLabel.textColor = Color.Navy
    fromLabel.font = Font.TextFieldPlaceholder
    fromPlaceTextField?.leftView = fromLabel
    fromPlaceTextField?.leftViewMode = .always

    let toLabel = UILabel(frame: fromPlaceTextField!.frame)
    toLabel.text = "To"
    toLabel.textColor = Color.Navy
    toLabel.font = Font.TextFieldPlaceholder
    toPlaceTextField?.leftView = toLabel
    toPlaceTextField?.leftViewMode = .always

    let dateLabel = UILabel(frame: fromPlaceTextField!.frame)
    dateLabel.text = "Date"
    dateLabel.textColor = Color.Gray
    dateLabel.font = Font.TextFieldPlaceholder
    dateTextField?.leftView = dateLabel
    dateTextField?.leftViewMode = .always
  }

  func setupDatePicker() {
    dateFormatter = DateFormatter()
    dateFormatter?.dateStyle = .medium
    dateFormatter?.timeStyle = .short

    datePicker = UIDatePicker()
    datePicker?.minuteInterval = 15

    let toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
    toolBar.sizeToFit()

    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDone))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancel))

    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true

    dateTextField?.inputView = datePicker
    dateTextField?.inputAccessoryView = toolBar
    date = DateHelper.nearestHalfHour()
    dateTextField?.text = dateFormatter?.string(from: date! as Date)
  }

  func onCancel() {
    dateTextField?.resignFirstResponder()
  }

  func onDone() {
    if let datePicker = datePicker {
      dateTextField?.text = dateFormatter?.string(from: datePicker.date)
      date = datePicker.date
    }
    search()
    dateTextField?.resignFirstResponder()
  }

  func search() {
    if toPlace != nil && fromPlace != nil && date != nil {
      if let date = date {
        let startDate = date.addingTimeInterval(-60 * 60 * 24)
        let endDate = date.addingTimeInterval(60 * 60 * 24)

        rides = allRides?.filter({ (ride) -> Bool in
          return ride.date?.compare(startDate as Date) == .orderedDescending &&
            ride.date?.compare(endDate as Date) == .orderedAscending
        })

        //Location(
        let passengerRide = Ride(fromPlace: fromPlace!, toPlace: toPlace!)
        rides?.sort { (ride1, ride2) -> Bool in
          return getDistance(ride1: ride1, ride2: passengerRide) < getDistance(ride1: ride2, ride2: passengerRide)
        }
      }

      emptyImage = "empty"
      emptyTitle = Empty.SearchTitle
      emptyMessage = Empty.SearchMessage
      tableView?.reloadData()
    }
  }

  func getDistance(ride1: Ride, ride2: Ride) -> Double {
    var distance = 0.0
    if let fromCoordinate1 = ride1.fromLocation?.place?.coordinate {
      if let toCoordinate1 = ride1.toLocation?.place?.coordinate {
        if let fromCoordinate2 = ride2.fromLocation?.place?.coordinate {
          if let toCoordinate2 = ride2.toLocation?.place?.coordinate {
            distance += GMSGeometryDistance(fromCoordinate1, fromCoordinate2)
            distance += GMSGeometryDistance(toCoordinate1, toCoordinate2)
            return distance
          }
        }
      }
    }
    return Double.infinity
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toAutocomplete" {
      if let navVC = segue.destination as? UINavigationController {
        if let vc = navVC.topViewController as? AutocompleteViewController, let textField = sender as? UITextField {
          autocompleteTextField = textField
          vc.delegate = self
          vc.initialText = textField.text
          vc.user = user
        }
      }
    } else if segue.identifier == "toPassengerRideDetails" {
      if let vc = segue.destination as? PassengerRideDetailsViewController {
        if let cell = sender as? RideTableViewCell {
          vc.user = user
          vc.ride = cell.ride
        }
      }
    }
  }

}

// MARK: - AutocompleteDelegate
extension SearchViewController: AutocompleteDelegate {

  func onPlaceSelected(placePrediction place: GMSPlace?) {
    autocompleteTextField?.text = place?.formattedAddress

    if autocompleteTextField == toPlaceTextField {
      toPlace = place
    } else {
      fromPlace = place
    }

    search()
  }

}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == dateTextField {
      textField.textColor = Color.Navy
      datePicker?.date = DateHelper.nearestHalfHour() as Date
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == dateTextField {
      textField.textColor = UIColor.black
    }
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == dateTextField {
      return true
    }
    performSegue(withIdentifier: "toAutocomplete", sender: textField)
    return false
  }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let rides = rides {
      return rides.count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath as IndexPath)

    if let ride = rides?[indexPath.row] {
      if let rideCell = cell as? RideTableViewCell {
        rideCell.textLabel?.text = ride.getFormattedLocation()
        rideCell.detailTextLabel?.text = ride.getFormattedDate()

        rideCell.ride = ride
        return rideCell
      }
    }

    return cell
  }

}
