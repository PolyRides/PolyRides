//
//  FirebaseConnection.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase
import FBSDKLoginKit

class FirebaseConnection {

  static let ref = Firebase(url: "https://poly-rides.firebaseio.com")

  static let FBErrorMessage = "An error occured while connecting to Facebook. Please try again."
  static let FBErrorTitle = "Authentication Error"

  static let ChangePasswordSuccess = "ChangePasswordSuccess"
  static let ResetPasswordSuccess = "ResetPasswordSuccess"
  static let TemporaryPassword = "TemporaryPassword"
  static let LoginSuccess = "LoginSuccess"
  static let LoginError = "LoginError"
  static let FBError = "FBError"

  static func pushUserToFirebase(user: User) {
    if let id = user.id {
      ref.childByAppendingPath("users/\(id)").updateChildValues(user.toAnyObject())
    }
  }

  static func resetPasswordForEmail(email: String) {
    print(email)
    FirebaseConnection.ref.resetPasswordForUser(email) { error in
      if error == nil {
        let notification = FirebaseConnection.ResetPasswordSuccess
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: email)
      } else {
        let notification = FirebaseConnection.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
      }
    }
  }

  static func changePasswordForUser(user: User, temporaryPassword: String, newPassword: String) {
    FirebaseConnection.ref.changePasswordForUser(user.email, fromOld: temporaryPassword,
      toNew: newPassword) { error in
        if error == nil {
          let notification = FirebaseConnection.LoginSuccess
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
        } else {
          let notification = FirebaseConnection.LoginError
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
          let notification = FirebaseConnection.LoginSuccess
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: user)
        }
      } else {
        let notification = FirebaseConnection.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
      }
    }
  }

  static func authWithFacebook() {
    let token = FBSDKAccessToken.currentAccessToken().tokenString
    FirebaseConnection.ref.authWithOAuthProvider("facebook", token: token) { error, authData in
      print(authData.uid)
      let user = User(withAuthData: authData)
      if error == nil {
        FirebaseConnection.pushUserToFirebase(user)
        let notification = FirebaseConnection.LoginSuccess
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: user)
      } else {
        let notification = FirebaseConnection.FBError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
      }
    }
  }

  static func authUser(email: String, password: String) {
    FirebaseConnection.ref.authUser(email, password: password) { error, authData in
      var notification = ""

      if error == nil {
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          let user = User(withAuthData: authData)
          if temporaryPassword {
            notification = FirebaseConnection.TemporaryPassword
          } else {
            notification = FirebaseConnection.LoginSuccess
          }
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: user)
        }
      } else {
        notification = FirebaseConnection.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
      }
    }

  }

}
