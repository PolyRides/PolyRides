//
//  Conversation.swift
//  PolyRides
//
//  Created by Max Parelius on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FirebaseDatabase

class Conversation {

  var id: String?
  var timestamp: Date?
  var lastMessageDate: Date?
  var lastMessageText: String?
  var ride: Ride?
  var driver: User?
  var driverIsTyping: Bool?
  var passenger: User?
  var passengerIsTyping: Bool?

  init(ride: Ride, driver: User, passenger: User) {
    self.timestamp = Date()
    self.lastMessageDate = Date()
    self.lastMessageText = ""
    self.ride = ride
    self.driver = driver
    self.driverIsTyping = false
    self.passenger = passenger
    self.passengerIsTyping = false
  }

  init(fromSnapshot snapshot: FIRDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
      if let timestamp = dictionary["timestamp"] as? Double {
        self.timestamp = Date(timeIntervalSince1970: timestamp)
      }
      if let lastMessageDate = dictionary["lastMessageDate"] as? Double {
        self.lastMessageDate = Date(timeIntervalSince1970: lastMessageDate)
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

  func toAnyObject() -> [String: Any] {
    var dictionary = [String : Any]()

    if let timestamp = timestamp {
      dictionary["timestamp"] = timestamp.timeIntervalSince1970
    }
    if let lastMessageText = lastMessageText {
      dictionary["lastMessageText"] = lastMessageText
    }
    dictionary["lastMessageDate"] = lastMessageDate?.timeIntervalSince1970
    dictionary["rideId"] = ride?.id
    dictionary["driverId"] = driver?.id
    dictionary["driverIsTyping"] = driverIsTyping
    dictionary["passengerId"] = passenger?.id
    dictionary["passengerIsTyping"] = passengerIsTyping
    return dictionary
  }

}
