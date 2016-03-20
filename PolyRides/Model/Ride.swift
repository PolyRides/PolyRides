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
  var timestamp: NSDate?

  init(driver: User, date: NSDate, seats: Int?, description: String, cost: Int?) {
    self.driver = driver
    self.date = date
    self.seatsAvailable = seats
    self.description = description
    self.costPerSeat = cost
  }

  init(fromSnapshot snapshot: FDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
      if let driverId = dictionary["driverId"] as? String {
        self.driver = User(id: driverId)
      }
      if let date = dictionary["date"] as? Double {
        self.date = NSDate(timeIntervalSince1970: date)
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

      fromLocation = getLocationFromDictionary(dictionary, place: "fromPlaceId", city: "fromPlaceCity")
      toLocation = getLocationFromDictionary(dictionary, place: "toPlaceId", city: "toPlaceCity")
    }
  }

  func getLocationFromDictionary(dictionary: [String: AnyObject], place: String, city: String) -> Location? {
    if let placeId = dictionary[place] as? String {
      if let city = dictionary[city] as? String {
        return Location(placeId: placeId, city: city)
      }
    }
    return nil
  }

  func toAnyObject() -> [String: AnyObject] {
    var dictionary = [String : AnyObject]()

    if let timestamp = timestamp {
      dictionary["timestamp"] = timestamp.timeIntervalSince1970
    }
    dictionary["driverId"] = driver?.id
    dictionary["date"] = date?.timeIntervalSince1970
    dictionary["fromPlaceId"] = fromLocation?.place?.placeID
    dictionary["fromPlaceCity"] = fromLocation?.city
    dictionary["toPlaceId"] = toLocation?.place?.placeID
    dictionary["toPlaceCity"] = toLocation?.city
    dictionary["seatsAvailable"] = seatsAvailable
    dictionary["totalSeats"] = totalSeats
    dictionary["description"] = description
    dictionary["costPerSeat"] = costPerSeat

    return dictionary
  }

}
