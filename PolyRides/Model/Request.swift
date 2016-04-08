//
//  Request.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/31/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class Request {

  var id: String?
  var ride: Ride?
  var accepted: Bool?
  var passenger: User?

  init(fromSnapshot snapshot: FDataSnapshot, ride: Ride, passenger: User) {
    self.ride = ride
    self.passenger = passenger
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
      if let accepted = dictionary["accepted"] as? Bool {
        self.accepted = accepted
      }
    }
  }

}
