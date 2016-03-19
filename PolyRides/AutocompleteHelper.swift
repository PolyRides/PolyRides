//
//  GooglePlacesAutocomplete.swift
//  GooglePlacesAutocomplete
//
//  Created by Howard Wilson on 10/02/2015.
//  Copyright (c) 2015 Howard Wilson. All rights reserved.
//

import UIKit

public let ErrorDomain: String = "GooglePlacesAutocompleteErrorDomain"

public struct LocationBias {
  public let latitude: Double
  public let longitude: Double
  public let radius: Int

  public init(latitude: Double = 0, longitude: Double = 0, radius: Int = 20000000) {
    self.latitude = latitude
    self.longitude = longitude
    self.radius = radius
  }

  public var location: String {
    return "\(latitude),\(longitude)"
  }
}

public enum PlaceType: CustomStringConvertible {
  case All
  case Geocode
  case Address
  case Establishment
  case Regions
  case Cities

  public var description : String {
    switch self {
    case .All: return ""
    case .Geocode: return "geocode"
    case .Address: return "address"
    case .Establishment: return "establishment"
    case .Regions: return "(regions)"
    case .Cities: return "(cities)"
    }
  }
}

public class Place: NSObject {
  public let id: String
  public let desc: String
  public var apiKey: String?

  override public var description: String {
    get { return desc }
  }

  public init(id: String, description: String) {
    self.id = id
    self.desc = description
  }

  public convenience init(prediction: [String: AnyObject], apiKey: String?) {
    self.init(
      id: prediction["place_id"] as! String,
      description: prediction["description"] as! String
    )

    self.apiKey = apiKey
  }

  /**
   Call Google Place Details API to get detailed information for this place

   Requires that Place#apiKey be set

   - parameter result: Callback on successful completion with detailed place information
   */
  public func getDetails(result: PlaceDetails -> ()) {
    GooglePlaceDetailsRequest(place: self).request(result)
  }
}

public class PlaceDetails: CustomStringConvertible {
  public let name: String
  public let latitude: Double
  public let longitude: Double
  public let raw: [String: AnyObject]

  public init(json: [String: AnyObject]) {
    let result = json["result"] as! [String: AnyObject]
    let geometry = result["geometry"] as! [String: AnyObject]
    let location = geometry["location"] as! [String: AnyObject]

    self.name = result["name"] as! String
    self.latitude = location["lat"] as! Double
    self.longitude = location["lng"] as! Double
    self.raw = json
  }

  public var description: String {
    return "PlaceDetails: \(name) (\(latitude), \(longitude))"
  }
}

public protocol AutocompleteDelegate {
  func placesFound(places: [Place])
  func placeSelected(place: Place, sender: AnyObject)
  func placeViewClosed()
}