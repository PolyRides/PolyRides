//
//  SearchViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/27/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps

class SearchViewController: TableViewController {

  let calendar = NSCalendar.currentCalendar()

  var user: User?
  var allRides: [Ride]?
  var rides: [Ride]?
  var autocompleteTextField: UITextField?
  var date: NSDate?
  var datePicker: UIDatePicker?
  var dateFormatter: NSDateFormatter?
  var fromPlace: GMSPlace?
  var toPlace: GMSPlace?

  @IBOutlet weak var fromPlaceTextField: UITextField?
  @IBOutlet weak var toPlaceTextField: UITextField?
  @IBOutlet weak var dateTextField: UITextField?
  @IBOutlet weak var placeStackView: UIStackView?

  @IBAction func switchToFromAction(sender: AnyObject) {
    let tempPlace = toPlace
    let tempText = toPlaceTextField?.text
    toPlace = fromPlace
    toPlaceTextField?.text = fromPlaceTextField?.text
    fromPlace = tempPlace
    fromPlaceTextField?.text = tempText
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.dataSource = self
    fromPlaceTextField?.delegate = self
    toPlaceTextField?.delegate = self
    dateTextField?.delegate = self

    emptyTitle = Empty.BeginSearchTitle
    emptyMessage = Empty.BeginSearchMessage
    emptyImage = "arrow"

    setupDatePicker()
  }

  func setupTextFields() {
    let fromLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 50, height: fromPlaceTextField!.frame.size.height))
    fromLabel.text = "From"
    fromLabel.textColor = Color.Navy
    fromLabel.font = Font.TextFieldPlaceholder
    fromPlaceTextField?.leftView = fromLabel
    fromPlaceTextField?.leftViewMode = .Always

    let toLabel = UILabel(frame: fromPlaceTextField!.frame)
    toLabel.text = "To"
    toLabel.textColor = Color.Navy
    toLabel.font = Font.TextFieldPlaceholder
    toPlaceTextField?.leftView = toLabel
    toPlaceTextField?.leftViewMode = .Always

    let dateLabel = UILabel(frame: fromPlaceTextField!.frame)
    dateLabel.text = "Date"
    dateLabel.textColor = Color.Gray
    dateLabel.font = Font.TextFieldPlaceholder
    dateTextField?.leftView = dateLabel
    dateTextField?.leftViewMode = .Always
  }

  func setupDatePicker() {
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
    date = DateHelper.nearestHalfHour()
    dateTextField?.text = dateFormatter?.stringFromDate(date!)
  }

  func onCancel() {
    dateTextField?.resignFirstResponder()
  }

  func onDone() {
    if let datePicker = datePicker {
      dateTextField?.text = dateFormatter?.stringFromDate(datePicker.date)
      date = datePicker.date
    }
    search()
    dateTextField?.resignFirstResponder()
  }

  func search() {
    if toPlace != nil && fromPlace != nil && date != nil {
      if let date = date {
        let startDate = date.dateByAddingTimeInterval(-60 * 60 * 24)
        let endDate = date.dateByAddingTimeInterval(60 * 60 * 24)

        rides = allRides?.filter({ (ride) -> Bool in
          return ride.date?.compare(startDate) == .OrderedDescending && ride.date?.compare(endDate) == .OrderedAscending
        })

        //Location(
        let passengerRide = Ride(fromPlace: fromPlace!, toPlace: toPlace!)
        rides?.sortInPlace { (ride1, ride2) -> Bool in
          return getDistance(ride1, ride2: passengerRide) < getDistance(ride2, ride2: passengerRide)
        }
      }

      emptyImage = "empty"
      emptyTitle = Empty.SearchTitle
      emptyMessage = Empty.SearchMessage
      tableView?.reloadData()
    }
  }

  func getDistance(ride1: Ride, ride2: Ride) -> Double? {
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
    return nil
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toAutocomplete" {
      if let navVC = segue.destinationViewController as? UINavigationController {
        if let vc = navVC.topViewController as? AutocompleteViewController, let textField = sender as? UITextField {
          autocompleteTextField = textField
          vc.delegate = self
          vc.initialText = textField.text
        }
      }
    } else if segue.identifier == "toPassengerRideDetails" {
      if let vc = segue.destinationViewController as? PassengerRideDetailsViewController {
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

  func onPlaceSelected(place: GMSPlace?) {
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

  func textFieldDidBeginEditing(textField: UITextField) {
    if textField == dateTextField {
      textField.textColor = Color.Navy
      datePicker?.date = DateHelper.nearestHalfHour()
    }
  }

  func textFieldDidEndEditing(textField: UITextField) {
    if textField == dateTextField {
      textField.textColor = UIColor.blackColor()
    }
  }

  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if textField == dateTextField {
      return true
    }
    performSegueWithIdentifier("toAutocomplete", sender: textField)
    return false
  }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let rides = rides {
      return rides.count
    }
    return 0
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("rideCell", forIndexPath: indexPath)

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
