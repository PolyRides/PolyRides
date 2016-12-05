//
//  GoogleMapsHelper.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps
import GooglePlaces

class GoogleMapsHelper {

  static let PlacesClient = GMSPlacesClient()

}


// Extract the fields from Google Maps address components.
extension Collection where Iterator.Element == GMSAddressComponent {
  var streetAddress: String? {
    return "\(valueForKey(key: "street_number")) \(valueForKey(key: kGMSPlaceTypeRoute))"
  }

  var city: String? {
    return valueForKey(key: kGMSPlaceTypeLocality)
  }

  var state: String? {
    return valueForKey(key: kGMSPlaceTypeAdministrativeAreaLevel1)
  }

  var zipCode: String? {
    return valueForKey(key: kGMSPlaceTypePostalCode)
  }

  var country: String? {
    return valueForKey(key: kGMSPlaceTypeCountry)
  }

  func valueForKey(key: String) -> String? {
    return filter { $0.type == key }.first?.name
  }
}
