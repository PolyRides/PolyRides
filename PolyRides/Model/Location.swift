//
//  Location.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps

class Location {

  var place: GMSPlace?
  var city: String?

  init(place: GMSPlace, city: String) {
    self.place = place
    self.city = city
  }

  init(placeId: String, city: String) {
    self.city = city
    GoogleMapsHelper.PlacesClient.lookUpPlaceID(placeId) { [weak self] place, error in
      if error == nil {
        self?.place = place
      }
    }
  }

}
