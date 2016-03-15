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
  static let CreateAccountSuccess = "CreateAccountSuccess"
  static let TemporaryPassword = "TemporaryPassword"
  static let AuthSuccess = "AuthSuccess"
  static let LoginError = "LoginError"
  static let FBSuccess = "FBSuccess"
  static let FBError = "FBError"

  static func pushUserToFirebase(user: User) {
    if let id = user.id {
      ref.childByAppendingPath("users/\(id)").updateChildValues(user.toAnyObject())
    }
  }

  static func resetPasswordForEmail(email: String) {
    FirebaseConnection.ref.resetPasswordForUser(email) { error in
      var notification = ""
      if error == nil {
        notification = FirebaseConnection.ResetPasswordSuccess
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
      } else {
        let notification = FirebaseConnection.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
      }
    }
  }

  static func changePasswordForUser(user: User, temporaryPassword: String, newPassword: String) {
    FirebaseConnection.ref.changePasswordForUser(user.email, fromOld: temporaryPassword,
      toNew: newPassword) { error in
        var notification = ""
        if error == nil {
          notification = FirebaseConnection.ChangePasswordSuccess
        } else {
          notification = FirebaseConnection.LoginError
        }
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)

    }
  }

  static func createUser(user: User, password: String) {
    FirebaseConnection.ref.createUser(user.email, password: password) { error, result in
      var notification = ""
      if error == nil {
        if let uid = result["uid"] as? String {
          user.id = uid
          pushUserToFirebase(user)
          notification = FirebaseConnection.CreateAccountSuccess
        }
      } else {
        notification = FirebaseConnection.LoginError
      }
      NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
    }
  }

  static func authWithFacebook() {
    let token = FBSDKAccessToken.currentAccessToken().tokenString
    FirebaseConnection.ref.authWithOAuthProvider("facebook", token: token) { error, authData in
      var notification = ""
      if error != nil {
        notification = FirebaseConnection.FBError
      } else {
        notification = FirebaseConnection.FBSuccess
      }
      NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
    }
  }

  static func authUser(inout user: User, password: String) {
    FirebaseConnection.ref.authUser(user.email, password: password) { error, authData in
      var notification = ""

      if error == nil {
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          user = User(withAuthData: authData)
          if temporaryPassword {
            notification = FirebaseConnection.TemporaryPassword
          } else {
            notification = FirebaseConnection.AuthSuccess
          }
        }
      } else {
        notification = FirebaseConnection.LoginError
      }
      NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)

    }

  }

}
