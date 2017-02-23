//
//  Ride.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FirebaseDatabase
import GooglePlaces

func == (lhs: Ride, rhs: Ride) -> Bool {
  return lhs.id == rhs.id
}

class Ride: Equatable {

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
  var driverIId: String?
  var driverId: String?
  var passengers = [String: String]()

  init(driver: User, date: NSDate, seats: Int?, description: String, cost: Int?) {
    self.driver = driver
    self.date = date
    self.seatsAvailable = seats
    self.description = description
    self.costPerSeat = cost
    self.driverIId = driver.instanceID
    self.driverId = driver.id
  }

  init(fromPlace: GMSPlace, toPlace: GMSPlace) {
    self.fromLocation = Location(place: fromPlace, city: "")
    self.toLocation = Location(place: toPlace, city: "")
  }

  init(fromSnapshot snapshot: FIRDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
      if let driverId = dictionary["driverId"] as? String {
        let driver = User(id: driverId)
        self.driver = driver
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
      if let driverIId = dictionary["driverInstanceId"] as? String {
        self.driverIId = driverIId
      }
      if let driverId = dictionary["driverId"] as? String {
        self.driverId = driverId
      }
      if let passengers = dictionary["passengers"] as? [String: String] {
        self.passengers = passengers
      }

      fromLocation = getLocationFromDictionary(dictionary: dictionary, place: "fromPlaceId", city: "fromPlaceCity")
      toLocation = getLocationFromDictionary(dictionary: dictionary, place: "toPlaceId", city: "toPlaceCity")
    }

    RideService().getUpdatedUserDataForRide(ride: self)
  }

  func getDriverInstanceID() -> String {
    return driverIId!
  }

  func getLocationFromDictionary(dictionary: [String: AnyObject], place: String, city: String) -> Location? {
    if let placeId = dictionary[place] as? String {
      if let city = dictionary[city] as? String {
        return Location(placeId: placeId, city: city)
      }
    }
    return nil
  }

  func getFormattedDate() -> String {
    if let date = date {
      let timeFormatter = DateFormatter()
      timeFormatter.dateFormat = "EEEE, MMM dd"
      let day = timeFormatter.string(from: date as Date)
      timeFormatter.dateFormat = "h:mm a"
      let time = timeFormatter.string(from: date as Date)

      return "\(day) at \(time)"
    }
    return ""
  }

  func getFormattedLocation() -> String {
    if let fromCity = fromLocation?.city {
      if let toCity = toLocation?.city {
        return "\(fromCity) → \(toCity)"
      }
    }
    return ""
  }

  func toAnyObject() -> [String: Any] {
    var dictionary = [String : Any]()

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
    dictionary["driverInstanceId"] = driverIId
    dictionary["driverId"] = driverId
    dictionary["passengers"] = passengers

    return dictionary
  }

}
