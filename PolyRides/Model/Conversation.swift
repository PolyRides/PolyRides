//
//  Conversation.swift
//  PolyRides
//
//  Created by Max Parelius on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class Conversation {

  var id: String?
  var timestamp: NSDate?
  var lastUpdated: NSDate?
  var lastMessage: Message?
  var ride: Ride?
  var driver: User?
  var driverIsTyping: Bool?
  var passenger: User?
  var passengerIsTyping: Bool?

  init(ride: Ride, driver: User, passenger: User) {
    self.timestamp = NSDate()
    self.lastUpdated = NSDate()
    self.lastMessage = nil
    self.ride = ride
    self.driver = driver
    self.driverIsTyping = false
    self.passenger = passenger
    self.passengerIsTyping = false
  }

  init(fromSnapshot snapshot: FDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
      if let timestamp = dictionary["timestamp"] as? Double {
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
      }
      if let lastUpdated = dictionary["lastUpdated"] as? Double {
        self.lastUpdated = NSDate(timeIntervalSince1970: lastUpdated)
      }
      if let driverId = dictionary["driverId"] as? String {
        let driver = User(id: driverId)
        self.driver = driver
      }
      if let driverIsTypingVal = dictionary["driverIsTyping"] as? Bool {
        self.driverIsTyping = driverIsTypingVal
      }
      if let passengerId = dictionary["passengerId"] as? String {
        let passenger = User(id: passengerId)
        self.passenger = passenger
      }
      if let passengerIsTypingVal = dictionary["passengerIsTyping"] as? Bool {
        self.passengerIsTyping = passengerIsTypingVal
      }
    }
  }

  func toAnyObject() -> [String: AnyObject] {
    var dictionary = [String : AnyObject]()

    if let timestamp = timestamp {
      dictionary["timestamp"] = timestamp.timeIntervalSince1970
    }
    dictionary["lastUpdated"] = lastUpdated?.timeIntervalSince1970
    dictionary["lastMessage"] = lastMessage?.id
    dictionary["rideId"] = ride?.id
    dictionary["driverId"] = driver?.id
    dictionary["driverIsTyping"] = driverIsTyping
    dictionary["passengerId"] = passenger?.id
    dictionary["passengerIsTyping"] = passengerIsTyping
    return dictionary
  }

}
