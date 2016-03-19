//
//  AutocompleteViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

// MARK: - GooglePlacesAutocomplete
public class AutocompleteViewController: UIViewController {

  let apiKey = "AIzaSyBmxCispciOMZhn4FNbRPv_-Rcj8r_AtAk"

  var places = [Place]()
  var sender: AnyObject?
  var delegate: AutocompleteDelegate?

  @IBOutlet weak var searchBar: UISearchBar?
  @IBOutlet weak var tableView: UITableView?

  @IBAction func cancelButtonAction(sender: AnyObject) {
    self.view.endEditing(true)
    delegate?.placeViewClosed()
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    searchBar?.delegate = self

    let defaultCenter = NSNotificationCenter.defaultCenter()
    var selector = Selector("keyboardWasShown:")
    var name = UIKeyboardWillShowNotification
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)

    selector = Selector("keyboardWillBeHidden:")
    name = UIKeyboardWillHideNotification
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  public override func viewWillAppear(animated: Bool) {
    searchBar?.becomeFirstResponder()

    super.viewWillAppear(animated)
  }

  func keyboardWasShown(notification: NSNotification) {
    if isViewLoaded() && view.window != nil {
      let info: Dictionary = notification.userInfo!
      let keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size)!
      let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)

      tableView?.contentInset = contentInsets;
      tableView?.scrollIndicatorInsets = contentInsets;
    }
  }

  func keyboardWillBeHidden(notification: NSNotification) {
    if isViewLoaded() && view.window != nil {
      self.tableView?.contentInset = UIEdgeInsetsZero
      self.tableView?.scrollIndicatorInsets = UIEdgeInsetsZero
    }
  }

}
//public class GooglePlacesAutocomplete: UINavigationController {
//  public var gpaViewController: GooglePlacesAutocompleteContainer!
//  public var closeButton: UIBarButtonItem!
//  public var sender: AnyObject? {
//    didSet {
//      gpaViewController.sender = sender
//    }
//  }
//
//  // Proxy access to container navigationItem
//  public override var navigationItem: UINavigationItem {
//    get { return gpaViewController.navigationItem }
//  }
//
//  public var placeDelegate: GooglePlacesAutocompleteDelegate? {
//    get { return gpaViewController.delegate }
//    set { gpaViewController.delegate = newValue }
//  }
//
//  public var locationBias: LocationBias? {
//    get { return gpaViewController.locationBias }
//    set { gpaViewController.locationBias = newValue }
//  }
//
//  public convenience init(apiKey: String, placeType: PlaceType = .All) {
//    let gpaViewController = GooglePlacesAutocompleteContainer(apiKey: apiKey, placeType: placeType)
//
//    self.init(rootViewController: gpaViewController)
//    self.gpaViewController = gpaViewController
//
//    closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "close")
//    closeButton.style = UIBarButtonItemStyle.Done
//
//    gpaViewController.navigationItem.leftBarButtonItem = closeButton
//    gpaViewController.navigationItem.title = "Enter Address"
//  }
//
//  func close() {
//    placeDelegate?.placeViewClosed?()
//  }
//
//  public func reset() {
//    gpaViewController.searchBar.text = ""
//    gpaViewController.searchBar(gpaViewController.searchBar, textDidChange: "")
//  }
//}

// MARK: - GooglePlacesAutocompleteContainer
//public class GooglePlacesAutocompleteContainer: UIViewController {
//  @IBOutlet public weak var searchBar: UISearchBar!
//  @IBOutlet weak var tableView: UITableView!
//  @IBOutlet weak var topConstraint: NSLayoutConstraint!
//
//  let apiKey = "AIzaSyBmxCispciOMZhn4FNbRPv_-Rcj8r_AtAk"
//
//  var delegate: GooglePlacesAutocompleteDelegate?
//  var places = [Place]()
//  var placeType: PlaceType = .All
//  var locationBias: LocationBias?
//  var sender: AnyObject?
//
//  convenience init(apiKey: String, placeType: PlaceType = .All) {
//    let bundle = NSBundle(forClass: GooglePlacesAutocompleteContainer.self)
//
//    self.init(nibName: "GooglePlacesAutocomplete", bundle: bundle)
//    self.placeType = placeType
//  }
//
//  deinit {
//    NSNotificationCenter.defaultCenter().removeObserver(self)
//  }
//
//  override public func viewWillLayoutSubviews() {
//    topConstraint.constant = topLayoutGuide.length
//  }
//
//  override public func viewDidLoad() {
//    super.viewDidLoad()
//
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
//
//    searchBar.becomeFirstResponder()
//    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//  }
//
//  func keyboardWasShown(notification: NSNotification) {
//    if isViewLoaded() && view.window != nil {
//      let info: Dictionary = notification.userInfo!
//      let keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size)!
//      let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
//
//      tableView.contentInset = contentInsets;
//      tableView.scrollIndicatorInsets = contentInsets;
//    }
//  }
//
//  func keyboardWillBeHidden(notification: NSNotification) {
//    if isViewLoaded() && view.window != nil {
//      self.tableView.contentInset = UIEdgeInsetsZero
//      self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
//    }
//  }
//}

// MARK: - GooglePlacesAutocomplete (UITableViewDataSource / UITableViewDelegate)
extension AutocompleteViewController: UITableViewDataSource, UITableViewDelegate {
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return places.count
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

    // Get the corresponding candy from our candies array
    let place = self.places[indexPath.row]

    // Configure the cell
    cell.textLabel!.text = place.description
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

    return cell
  }

  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let sender = sender {
      delegate?.placeSelected(self.places[indexPath.row], sender: sender)
    }
  }
}

// MARK: - GooglePlacesAutocomplete (UISearchBarDelegate)
extension AutocompleteViewController: UISearchBarDelegate {
  public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if (searchText == "") {
      self.places = []
      tableView?.hidden = true
    } else {
      getPlaces(searchText)
    }
  }

  /**
   Call the Google Places API and update the view with results.
   - parameter searchString: The search query
   */

  private func getPlaces(searchString: String) {
    let params = [
      "input": searchString,
      "types": PlaceType.Address.description,
      "key": apiKey ?? ""
    ]

    // TODO prefer california locations
    //    if let bias = locationBias {
    //      params["location"] = bias.location
    //      params["radius"] = bias.radius.description
    //    }

    if (searchString == ""){
      return
    }

    GooglePlacesRequestHelpers.doRequest(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json",
      params: params
      ) { json, error in
        if let json = json{
          if let predictions = json["predictions"] as? Array<[String: AnyObject]> {
            self.places = predictions.map { (prediction: [String: AnyObject]) -> Place in
              return Place(prediction: prediction, apiKey: self.apiKey)
            }
            self.tableView?.reloadData()
            self.tableView?.hidden = false
            self.delegate?.placesFound(self.places)
          }
        }
    }
  }
}

// MARK: - GooglePlaceDetailsRequest
class GooglePlaceDetailsRequest {
  let place: Place

  init(place: Place) {
    self.place = place
  }

  func request(result: PlaceDetails -> ()) {
    GooglePlacesRequestHelpers.doRequest(
      "https://maps.googleapis.com/maps/api/place/details/json",
      params: [
        "placeid": place.id,
        "key": place.apiKey ?? ""
      ]
      ) { json, error in
        if let json = json as? [String: AnyObject] {
          result(PlaceDetails(json: json))
        }
        if let error = error {
          // TODO: We should probably pass back details of the error
          print("Error fetching google place details: \(error)")
        }
    }
  }
}

// MARK: - GooglePlacesRequestHelpers
class GooglePlacesRequestHelpers {
  /**
   Build a query string from a dictionary
   - parameter parameters: Dictionary of query string parameters
   - returns: The properly escaped query string
   */
  private class func query(parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    for key in Array(parameters.keys).sort(<) {
      let value: AnyObject! = parameters[key]
      components += [(escape(key), escape("\(value)"))]
    }

    return (components.map{"\($0)=\($1)"} as [String]).joinWithSeparator("&")
  }

  private class func escape(string: String) -> String {
    let characterSet = NSCharacterSet.URLQueryAllowedCharacterSet()
    if let escapedString = string.stringByAddingPercentEncodingWithAllowedCharacters(characterSet) {
      return escapedString
    }
    return ""
  }

  private class func doRequest(url: String, params: [String: String], completion: (NSDictionary?,NSError?) -> ()) {
    let request = NSMutableURLRequest(
      URL: NSURL(string: "\(url)?\(query(params))")!
    )

    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
      self.handleResponse(data, response: response as? NSHTTPURLResponse, error: error, completion: completion)
    }

    task.resume()
  }

  private class func handleResponse(data: NSData!, response: NSHTTPURLResponse!, error: NSError!, completion: (NSDictionary?, NSError?) -> ()) {

    // Always return on the main thread...
    let done: ((NSDictionary?, NSError?) -> Void) = {(json, error) in
      dispatch_async(dispatch_get_main_queue(), {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        completion(json,error)
      })
    }

    if let error = error {
      print("GooglePlaces Error: \(error.localizedDescription)")
      done(nil,error)
      return
    }

    if response == nil {
      print("GooglePlaces Error: No response from API")
      let error = NSError(domain: ErrorDomain, code: 1001, userInfo: [NSLocalizedDescriptionKey:"No response from API"])
      done(nil,error)
      return
    }

    if response.statusCode != 200 {
      print("GooglePlaces Error: Invalid status code \(response.statusCode) from API")
      let error = NSError(domain: ErrorDomain, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey:"Invalid status code"])
      done(nil,error)
      return
    }

    let json: NSDictionary?
    do {
      json = try NSJSONSerialization.JSONObjectWithData(
        data,
        options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
    } catch {
      print("Serialisation error")
      let serialisationError = NSError(domain: ErrorDomain, code: 1002, userInfo: [NSLocalizedDescriptionKey:"Serialization error"])
      done(nil,serialisationError)
      return
    }

    if let status = json?["status"] as? String {
      if status != "OK" {
        print("GooglePlaces API Error: \(status)")
        let error = NSError(domain: ErrorDomain, code: 1002, userInfo: [NSLocalizedDescriptionKey:status])
        done(nil,error)
        return
      }
    }
    
    done(json,nil)
    
  }
}