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
  var fullName: String?
  var imageURL: String?

  init(email: String, firstName: String, lastName: String) {
    self.email = email
    self.firstName = firstName
    self.fullName = "\(firstName) \(lastName)"
  }

  init(withAuthData authData: FAuthData) {
    self.id = authData.uid
    if let email = authData.providerData["email"] as? NSString {
      self.email = String(email)
    }
    if let fullName = authData.providerData["displayName"] as? NSString {
      self.fullName = String(fullName)
      self.firstName = fullName.componentsSeparatedByString(" ")[0]
    }
    if let imageURL = authData.providerData["profileImageURL"] as? NSString {
      self.imageURL = String(imageURL)
    }
  }

  init(withSnapshot snapshot: FDataSnapshot) {
    if let dictionary = snapshot.value as? [String : AnyObject] {
      if let id = dictionary["id"] as? String {
        self.id = id
      }
      if let email = dictionary["email"] as? String {
        self.email = email
      }
      if let firstName = dictionary["firstName"] as? String {
        self.firstName = firstName
      }
      if let fullName = dictionary["fullName"] as? String {
        self.fullName = fullName
      }
      if let imageURL = dictionary["imageURL"] as? String {
        self.imageURL = imageURL
      }
    }
  }

  func toAnyObject() -> [String : AnyObject] {
    var dictionary = [String : AnyObject]()

    dictionary["id"] = id
    dictionary["email"] = email
    dictionary["firstName"] = firstName
    dictionary["fullName"] = fullName
    dictionary["imageURL"] = imageURL

    return dictionary
  }

  func pushToFirebase() {
    FirebaseConnection.pushUserToFirebase(self)
  }

}
