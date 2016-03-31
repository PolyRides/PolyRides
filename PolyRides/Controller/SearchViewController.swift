//
//  SearchViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/27/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps
import DZNEmptyDataSet

class SearchViewController: UIViewController {

  @IBOutlet weak var fromPlaceTextField: UITextField?
  @IBOutlet weak var toPlaceTextField: UITextField?
  @IBOutlet weak var dateTextField: UITextField?
  @IBOutlet weak var tableView: UITableView?

  let calendar = NSCalendar.currentCalendar()

  var allRides: [Ride]?
  var rides: [Ride]?
  var autocompleteTextField: UITextField?
  var date: NSDate?
  var datePicker: UIDatePicker?
  var dateFormatter: NSDateFormatter?
  var fromPlace: GMSPlace?
  var toPlace: GMSPlace?
  var messageEmpty = "Enter from and to locations and your departure date, and rides within 24 hours will show up."
  var titleEmpty = "Search for a ride."
  var imageName = "arrow"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.dataSource = self
    tableView?.emptyDataSetSource = self
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
    date = DateHelper.nearestHalfHour()
    dateTextField?.text = dateFormatter?.stringFromDate(date!)

    // Remove the cell separators in the empty table view.
    tableView?.tableFooterView = UIView()
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

        let passengerRide = Ride(fromPlace: fromPlace!, toPlace: toPlace!)
        rides?.sortInPlace { (ride1, ride2) -> Bool in
          return getDistance(ride1, ride2: passengerRide) < getDistance(ride2, ride2: passengerRide)
        }
      }

      imageName = "empty"
      titleEmpty = "No rides were found."
      messageEmpty = "We don't have any rides departing within 24 hours of the specified date, please check back later."
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

    search()
    dismissViewControllerAnimated(true, completion: nil)
  }

  func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
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
    autocompleteController.autocompleteFilter = filter
    autocompleteController.autocompleteBounds = bounds
    autocompleteController.delegate = self
    self.presentViewController(autocompleteController, animated: true, completion: nil)

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

// MARK: - DZNEmptyDataSetDataSource
extension SearchViewController: DZNEmptyDataSetSource {

  func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: imageName)
  }

  func imageAnimationForEmptyDataSet(scrollView: UIScrollView!) -> CAAnimation! {
    let animation = CABasicAnimation(keyPath: "transform")

    animation.fromValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
    animation.duration = 0.25
    animation.cumulative = true
    animation.repeatCount = MAXFLOAT

    return animation
  }


  func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let attributes = [
      NSFontAttributeName: UIFont.systemFontOfSize(18),
      NSForegroundColorAttributeName : UIColor.blackColor()]
    return NSAttributedString(string: titleEmpty, attributes: attributes)
  }

  func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
    paragraph.alignment = NSTextAlignment.Center
    let attributes = [
      NSFontAttributeName: UIFont.systemFontOfSize(14),
      NSForegroundColorAttributeName: UIColor.grayColor(),
      NSParagraphStyleAttributeName: paragraph]

    return NSAttributedString(string: messageEmpty, attributes: attributes)
  }

  func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
    return UIColor.whiteColor()
  }
}
