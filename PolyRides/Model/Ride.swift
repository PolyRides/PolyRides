//
//  Ride.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class Ride {

  var id: String?
  var driver: User?
  var date: NSDate?
  var fromLocation: Location?
  var toLocation: Location?
  var seatsAvailable: Int?
  var totalSeats: Int?
  var description: String?
  var costPerSeat: Int?

  init(driver: User, date: NSDate, seats: Int?, description: String, cost: Int?) {
    self.driver = driver
    self.date = date
    self.seatsAvailable = seats
    self.description = description
    self.costPerSeat = cost
  }

  init(withSnapshot snapshot: FDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
      if let driverId = dictionary["driver_id"] as? String {
        self.driver = User(id: driverId)
      }
      if let date = dictionary["date"] as? Double {
        self.date = NSDate(timeIntervalSince1970: date)
      }
      if let fromPlaceId = dictionary["from_place_id"] as? String {
        if let fromCity = dictionary["from_place_id"] as? String {
          fromLocation = Location(placeId: fromPlaceId, city: fromCity)
        }
      }
      if let toPlaceId = dictionary["to_place_id"] as? String {
        if let toCity = dictionary["to_place_id"] as? String {
          toLocation = Location(placeId: toPlaceId, city: toCity)
        }
      }
      if let seatsAvailable = dictionary["seatsAvailable"] as? Int {
        self.seatsAvailable = seatsAvailable
      }
      if let totalSeats = dictionary["totalSeats"] as? Int {
        self.totalSeats = totalSeats
      }
      if let description = dictionary["description"] as? String {
        self.description = description
      }
      if let costPerSeat = dictionary["costPerSeat"] as? Int {
        self.costPerSeat = costPerSeat
      }
    }
  }

  func toAnyObject() -> [String: AnyObject] {
    var dictionary = [String : AnyObject]()

    dictionary["timestamp"] = NSDate().timeIntervalSince1970
    dictionary["driver_id"] = driver?.id
    dictionary["date"] = date?.timeIntervalSince1970
    dictionary["from_place_id"] = fromLocation?.place?.placeID
    dictionary["from_city"] = fromLocation?.city
    dictionary["to_place_id"] = toLocation?.place?.placeID
    dictionary["to_city"] = toLocation?.city
    dictionary["seats_available"] = seatsAvailable
    dictionary["total_seats"] = totalSeats
    dictionary["description"] = description
    dictionary["cost_per_seat"] = costPerSeat

    return dictionary
  }

}
