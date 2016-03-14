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

  static func resetPasswordForEmail(email: String) {
    FirebaseConnection.ref.resetPasswordForUser(email) { error in
      if error == nil {
        let notification = LoginViewController.ResetPasswordSuccess
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
      } else {
        let notification = LoginViewController.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
      }
    }
  }

  static func changePasswordForUser(user: User, temporaryPassword: String, newPassword: String) {
    FirebaseConnection.ref.changePasswordForUser(user.email, fromOld: temporaryPassword,
      toNew: newPassword) { error in
        if error == nil {
          let notification = LoginViewController.ChangePasswordSuccess
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
        } else {
          let notification = LoginViewController.LoginError
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
        }
    }
  }

  static func createUser(user: User, password: String) {
    FirebaseConnection.ref.createUser(user.email, password: password) { error, result in
      if error == nil {
        if let uid = result["uid"] as? String {
          user.id = uid
          pushUserToFirebase(user)
          let notification = LoginViewController.CreateAccountSuccess
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
        }
      } else {
        let notification = LoginViewController.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
      }
    }
  }

}

