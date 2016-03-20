//
//  GoogleMapsHelper.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps

class GoogleMapsHelper {

  static let placesClient = GMSPlacesClient()

}


// Extract the fields from Google Maps address components.
extension CollectionType where Generator.Element == GMSAddressComponent {
  var streetAddress: String? {
    return "\(valueForKey("street_number")) \(valueForKey(kGMSPlaceTypeRoute))"
  }

  var city: String? {
    return valueForKey(kGMSPlaceTypeLocality)
  }

  var state: String? {
    return valueForKey(kGMSPlaceTypeAdministrativeAreaLevel1)
  }

  var zipCode: String? {
    return valueForKey(kGMSPlaceTypePostalCode)
  }

  var country: String? {
    return valueForKey(kGMSPlaceTypeCountry)
  }

  func valueForKey(key: String) -> String? {
    return filter { $0.type == key }.first?.name
  }

}
