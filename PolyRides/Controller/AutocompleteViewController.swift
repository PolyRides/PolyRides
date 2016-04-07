//
//  AutocompleteViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/5/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import UIKit
import GoogleMaps
import AddressBookUI

protocol AutocompleteDelegate {

  func onPlaceSelected(placePrediction: GMSPlace?)

}

enum AutocompleteSection: Int {

  case CurrentLocation = 0, AutocompleteResult = 1, PoweredByGoogle = 2

  static let AllSections = [CurrentLocation, AutocompleteResult, PoweredByGoogle]

}

class AutocompleteViewController: TableViewController {

  var predictions = [GMSAutocompletePrediction]()
  var delegate: AutocompleteDelegate?
  var fetcher: GMSAutocompleteFetcher?
  var locationManager = CLLocationManager()
  var initialText: String?
  var currentLocation: GMSPlace?

  override func viewDidLoad() {
    super.viewDidLoad()

    fetcher = GMSAutocompleteFetcher(bounds: Bounds.California, filter: Filter.US())
    fetcher?.delegate = self

    tableView?.delegate = self
    tableView?.dataSource = self

    let searchBar = UISearchBar()
    searchBar.sizeToFit()
    searchBar.showsCancelButton = true
    searchBar.becomeFirstResponder()
    searchBar.placeholder = "Search for place or address"
    searchBar.delegate = self
    searchBar.text = initialText
    navigationItem.titleView = searchBar

    GoogleMapsHelper.PlacesClient.currentPlaceWithCallback({ (placeLikelihoods, error) -> Void in
      if let placeLikelihood = placeLikelihoods?.likelihoods.first {
        self.currentLocation = placeLikelihood.place
        self.tableView?.reloadData()
      }
    })
  }

}

extension AutocompleteViewController: UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return AutocompleteSection.AllSections.count
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == AutocompleteSection.CurrentLocation.rawValue && currentLocation == nil {
      return 0
    }
    return UITableViewAutomaticDimension
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    if indexPath.section == AutocompleteSection.CurrentLocation.rawValue {
      let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath)
      cell.detailTextLabel?.text = currentLocation?.formattedAddress
      return cell
    } else if indexPath.section == AutocompleteSection.AutocompleteResult.rawValue {
      let cell = tableView.dequeueReusableCellWithIdentifier("AutocompleteCell", forIndexPath: indexPath)
      let prediction = predictions[indexPath.row]
      let regularFont = Font.TableRow
      let boldFont = Font.TableRowBold

      if let bolded = prediction.attributedPrimaryText.mutableCopy() as? NSMutableAttributedString {
        bolded.enumerateAttribute(kGMSAutocompleteMatchAttribute, inRange: NSMakeRange(0, bolded.length),
                                  options: .LongestEffectiveRangeNotRequired) {
                                    (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
          let font = (value == nil) ? regularFont : boldFont
          bolded.addAttribute(NSFontAttributeName, value: font, range: range)
        }
        cell.textLabel?.attributedText = bolded
        cell.detailTextLabel?.attributedText = prediction.attributedSecondaryText
      }

      return cell
    } else {
      return tableView.dequeueReusableCellWithIdentifier("GoogleCell", forIndexPath: indexPath)
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == AutocompleteSection.AutocompleteResult.rawValue {
      return predictions.count
    } else {
      return 1
    }
  }

}

extension AutocompleteViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == AutocompleteSection.AutocompleteResult.rawValue {
      let prediction = predictions[indexPath.row]
      if let placeID = prediction.placeID {
        GoogleMapsHelper.PlacesClient.lookUpPlaceID(placeID) { [weak self] place, error in
          if error == nil {
            self?.delegate?.onPlaceSelected(place)
            self?.dismissViewControllerAnimated(false, completion: nil)
          }
        }
      }
    } else {
      delegate?.onPlaceSelected(currentLocation)
      dismissViewControllerAnimated(false, completion: nil)
    }
  }

}

extension AutocompleteViewController: UISearchBarDelegate {

  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    fetcher?.sourceTextHasChanged(searchText)
  }

}

extension AutocompleteViewController: GMSAutocompleteFetcherDelegate {
  func didAutocompleteWithPredictions(predictions: [GMSAutocompletePrediction]) {
    self.predictions = predictions
    tableView?.reloadData()
  }

  func didFailAutocompleteWithError(error: NSError) {
    // TODO handle error
    print(error.localizedDescription)
  }

  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    dismissViewControllerAnimated(false, completion: nil)
  }
}
