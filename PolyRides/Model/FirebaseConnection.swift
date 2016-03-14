//
//  FirebaseConnection.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class FirebaseConnection {

  static let ref = Firebase(url: "https://poly-rides.firebaseio.com")

  static func pushUserToFirebase(user: User) {
    if let id = user.id {
      ref.childByAppendingPath("users/\(id)").updateChildValues(user.toAnyObject())
    }
  }

  static func resetPassword(user: User) {
    if let email = user.email {
      FirebaseConnection.ref.resetPasswordForUser(email, withCompletionBlock: { error in
        if error != nil {
          let notifcation = LoginViewController.ResetPasswordError
          NSNotificationCenter.defaultCenter().postNotificationName(notifcation, object: error)
        } else {
          let notification = LoginViewController.ResetPasswordSuccess
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
        }
      })
    }
  }



}
