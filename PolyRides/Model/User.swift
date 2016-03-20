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
  var email: String?
  var firstName: String?
  var lastName: String?
  var imageURL: String?

  init() {
  }

  init(id: String) {
    self.id = id
  }

  init(email: String, firstName: String, lastName: String) {
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
  }

  init(withAuthData authData: FAuthData) {
    self.id = authData.uid
    if let email = authData.providerData["email"] as? NSString {
      self.email = String(email)
    }
    if let fullName = authData.providerData["displayName"] as? NSString {
      let components = fullName.componentsSeparatedByString(" ")
      self.firstName = components.first
      self.lastName = components.last
    }
    if let imageURL = authData.providerData["profileImageURL"] as? NSString {
      self.imageURL = String(imageURL)
    }
  }

  init(withSnapshot snapshot: FDataSnapshot) {
    updateFromSnapshot(snapshot)
  }

  func updateFromSnapshot(snapshot: FDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      self.id = snapshot.key
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
    }
  }

  func toAnyObject() -> [String : AnyObject] {
    var dictionary = [String : AnyObject]()

    dictionary["email"] = email
    dictionary["firstName"] = firstName
    dictionary["lastName"] = lastName
    dictionary["imageURL"] = imageURL

    return dictionary
  }

}
