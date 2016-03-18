//
//  RidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/16/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GooglePlacesAutocomplete

class RidesViewController: UIViewController, GooglePlacesAutocompleteDelegate {

  var user: User?


  override func viewDidLoad() {
    super.viewDidLoad()

    // populate user field from tab bar controller
    // query for all rides
  }

  func placeSelected(place: Place) {
    print("place was selected!")
  }

}
