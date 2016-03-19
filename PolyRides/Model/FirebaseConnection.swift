//
//  FirebaseConnection.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase
import FBSDKLoginKit

<<<<<<< HEAD

protocol FirebaseLoginDelegate: class {

  func passwordResetSuccess(email: String)
  func loginError(error: NSError)
  func loginSuccess(user: User)
  func temporaryPassword(user: User)

}

class FirebaseConnection {

  static let service = FirebaseConnection()
  
  let ref = Firebase(url: "https://poly-rides.firebaseio.com")

  var loginDelegate: FirebaseLoginDelegate?

  func pushUserToFirebase(user: User) {
=======
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
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
    if let id = user.id {
      ref.childByAppendingPath("users/\(id)").updateChildValues(user.toAnyObject())
    }
  }

<<<<<<< HEAD
  func pushRideToFirebase(ride: Ride) {
    let rideRef = ref.childByAppendingPath("rides").childByAutoId()
    if let id = ride.driver?.id {
      let userRideRef = ref.childByAppendingPath("users/\(id)/rides/\(rideRef.key)")
      userRideRef.setValue(true)
      rideRef.setValue(ride.toAnyObject())
    }
  }

  func resetPasswordForEmail(email: String) {
    print(email)
    ref.resetPasswordForUser(email) { error in
      if error == nil {
        self.loginDelegate?.passwordResetSuccess(email)
      } else {
        self.loginDelegate?.loginError(error)
=======
  static func resetPasswordForEmail(email: String) {
    print(email)
    FirebaseConnection.ref.resetPasswordForUser(email) { error in
      if error == nil {
        let notification = FirebaseConnection.ResetPasswordSuccess
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: email)
      } else {
        let notification = FirebaseConnection.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
      }
    }
  }

<<<<<<< HEAD
  func changePasswordForUser(user: User, temporaryPassword: String, newPassword: String) {
    ref.changePasswordForUser(user.email, fromOld: temporaryPassword, toNew: newPassword) { error in
        if error == nil {
          self.loginDelegate?.loginSuccess(user)
        } else {
          self.loginDelegate?.loginError(error)
=======
  static func changePasswordForUser(user: User, temporaryPassword: String, newPassword: String) {
    FirebaseConnection.ref.changePasswordForUser(user.email, fromOld: temporaryPassword,
      toNew: newPassword) { error in
        if error == nil {
          let user = User()
          let notification = FirebaseConnection.LoginSuccess
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: user)
        } else {
          let notification = FirebaseConnection.LoginError
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
        }
    }
  }

<<<<<<< HEAD
  func createUser(user: User, password: String) {
    ref.createUser(user.email, password: password) { error, result in
      if error == nil {
        if let uid = result["uid"] as? String {
          user.id = uid
          self.loginDelegate?.loginSuccess(user)
        }
      } else {
        self.loginDelegate?.loginError(error)
=======
  static func createUser(user: User, password: String) {
    FirebaseConnection.ref.createUser(user.email, password: password) { error, result in
      if error == nil {
        if let uid = result["uid"] as? String {
          user.id = uid
          let notification = FirebaseConnection.LoginSuccess
          NSNotificationCenter.defaultCenter().postNotificationName(notification, object: user)
        }
      } else {
        let notification = FirebaseConnection.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
      }
    }
  }

<<<<<<< HEAD
  func authWithFacebook() {
    let token = FBSDKAccessToken.currentAccessToken().tokenString
    ref.authWithOAuthProvider("facebook", token: token) { error, authData in
      if error == nil {
        let user = User(withAuthData: authData)
        self.loginDelegate?.loginSuccess(user)
      } else {
        self.loginDelegate?.loginError(error)
=======
  static func authWithFacebook() {
    let token = FBSDKAccessToken.currentAccessToken().tokenString
    FirebaseConnection.ref.authWithOAuthProvider("facebook", token: token) { error, authData in
      if error == nil {
        let user = User(withAuthData: authData)
        let notification = FirebaseConnection.LoginSuccess
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: user)
      } else {
        let notification = FirebaseConnection.FBError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
      }
    }
  }

<<<<<<< HEAD
  func authUser(email: String, password: String) {
    ref.authUser(email, password: password) { error, authData in

      if error == nil {
        let user = User(withAuthData: authData)
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          if temporaryPassword {
            self.loginDelegate?.temporaryPassword(user)
          } else {
            self.loginDelegate?.loginSuccess(user)
          }
        }
      } else {

=======
  static func authUser(email: String, password: String) {
    FirebaseConnection.ref.authUser(email, password: password) { error, authData in
      var notification = ""

      if error == nil {
        let user = User(withAuthData: authData)
        notification = FirebaseConnection.LoginSuccess
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          if temporaryPassword {
            notification = FirebaseConnection.TemporaryPassword
          }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: user)
      } else {
        notification = FirebaseConnection.LoginError
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: error)
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
      }
    }
  }

<<<<<<< HEAD
  func updateValuesForUser(user: User) {
=======
  static func updateValuesForUser(user: User) {
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
    let userRef = ref.childByAppendingPath("users/\(user.id)")
    userRef.observeSingleEventOfType(.Value, withBlock: {
      snapshot in
      user.updateFromSnapshot(snapshot)
    })
  }

}
