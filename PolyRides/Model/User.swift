//
//  User.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/11/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class User {

  var id: String?
  var facebookId: String?
  var email: String?
  var firstName: String?
  var lastName: String?
  var imageURL: String?
  var timestamp: NSDate?
  var description: String?
  var car: Car?

  var savedRides = [Ride]()
  var verifications = [Verification]()
  var pendingVerifications = [Verification]()

  init() {
  }

  init(facebookId: String, name: String) {
    self.facebookId = facebookId
    let components = name.componentsSeparatedByString(" ")
    firstName = components.first
    lastName = components.last
    imageURL = "https://graph.facebook.com/\(facebookId)/picture?type=large"
  }

  init(id: String) {
    self.id = id
  }

  init(email: String, firstName: String, lastName: String) {
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
  }

  init(fromAuthData authData: FAuthData) {
    if let facebookId = authData.providerData["id"] as? String {
      self.facebookId = facebookId
      imageURL = "https://graph.facebook.com/\(facebookId)/picture?type=large"
    }

    if let email = authData.providerData["email"] as? NSString {
      self.email = String(email)
    }
    if let fullName = authData.providerData["displayName"] as? NSString {
      let components = fullName.componentsSeparatedByString(" ")
      self.firstName = components.first
      self.lastName = components.last
    }
  }

  init(fromSnapshot snapshot: FDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
      if let email = dictionary["email"] as? String {
        self.email = email
      }
    }
  }

  func updateFromSnapshot(snapshot: FDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
      if let facebookId = dictionary["facebookId"] as? String {
        self.facebookId = facebookId
      }
      if let email = dictionary["email"] as? String {
        self.email = email
      }
      if let firstName = dictionary["firstName"] as? String {
        self.firstName = firstName
      }
      if let lastName = dictionary["lastName"] as? String {
        self.lastName = lastName
      }
      if let imageURL = dictionary["imageURL"] as? String {
        self.imageURL = imageURL
      }
      if let description = dictionary["description"] as? String {
        self.description = description
      }
      if let carDictionary = dictionary["car"] as? [String: AnyObject] {
        extractCarFromDictionary(carDictionary)
      }
      if let verifications = dictionary["verifications"] as? [String: Bool] {
        for rawValue in verifications.keys {
          if let verification = Verification(rawValue: rawValue) {
            self.verifications.append(verification)
          }
        }
      }
      if let pendingVeritications = dictionary["pendingVerifications"] as? [String: AnyObject] {
        for pendingVerification in pendingVeritications {
          if let verification = Verification(rawValue: pendingVerification.0) {
            self.pendingVerifications.append(verification)
          }
        }
      }
    }
  }

  func extractCarFromDictionary(dictionary: [String: AnyObject]) {
    car = Car()
    if let model = dictionary["model"] as? String {
      car?.model = model
    }
    if let make = dictionary["make"] as? String {
      car?.make = make
    }
    if let year = dictionary["year"] as? Int {
      car?.year = year
    }
    if let color = dictionary["color"] as? String {
      car?.color = color
    }
  }

  func toAnyObject() -> [String : AnyObject] {
    var dictionary = [String : AnyObject]()

    dictionary["email"] = email
    dictionary["firstName"] = firstName
    dictionary["lastName"] = lastName
    dictionary["imageURL"] = imageURL

    if let facebookId = facebookId {
      dictionary["facebookId"] = facebookId
    }
    if let timestamp = timestamp {
      dictionary["timestamp"] = timestamp.timeIntervalSince1970
    }

    return dictionary
  }

  func getFullName() -> String {
    if let firstName = firstName {
      if let lastName = lastName {
        return "\(firstName) \(lastName)"
      }
      return "\(firstName)"
    }
    return ""
  }

}
