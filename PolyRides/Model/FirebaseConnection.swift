//
//  FirebaseConnection.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase
import FBSDKLoginKit


protocol FirebaseLoginDelegate: class {

  func onLoginError(error: NSError)
  func onLoginSuccess(user: User)

}

protocol FirebaseResetPasswordDelegate: class {

  func onPasswordResetSuccess(email: String)

}

protocol FirebaseTemporaryPasswordDelegate: class {

  func onHasTemporaryPassword(user: User)

}

class FirebaseConnection {

  static let service = FirebaseConnection()

  let ref = Firebase(url: "https://poly-rides.firebaseio.com")

  var loginDelegate: FirebaseLoginDelegate?
  var resetPasswordDelegate: FirebaseResetPasswordDelegate?
  var temporaryPasswordDelegate: FirebaseTemporaryPasswordDelegate?

  func pushUserToFirebase(user: User) {
    if let id = user.id {
      ref.childByAppendingPath("users/\(id)").updateChildValues(user.toAnyObject())
    }
  }

  func pushRideToFirebase(ride: Ride) {
    print(ride.id)
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
        self.resetPasswordDelegate?.onPasswordResetSuccess(email)
      } else {
        self.loginDelegate?.onLoginError(error)
      }
    }
  }

  func changePasswordForUser(user: User, temporaryPassword: String, newPassword: String) {
    ref.changePasswordForUser(user.email, fromOld: temporaryPassword, toNew: newPassword) { error in
        if error == nil {
          self.loginDelegate?.onLoginSuccess(user)
        } else {
          self.loginDelegate?.onLoginError(error)
        }
    }
  }

  func createUser(user: User, password: String) {
    ref.createUser(user.email, password: password) { error, result in
      if error == nil {
        if let uid = result["uid"] as? String {
          user.id = uid
          self.loginDelegate?.onLoginSuccess(user)
        }
      } else {
        self.loginDelegate?.onLoginError(error)
      }
    }
  }

  func authWithFacebook() {
    let token = FBSDKAccessToken.currentAccessToken().tokenString
    ref.authWithOAuthProvider("facebook", token: token) { error, authData in
      if error == nil {
        let user = User(withAuthData: authData)
        self.loginDelegate?.onLoginSuccess(user)
      } else {
        self.loginDelegate?.onLoginError(error)
      }
    }
  }

  func authUser(email: String, password: String) {
    ref.authUser(email, password: password) { error, authData in

      if error == nil {
        let user = User(withAuthData: authData)
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          if temporaryPassword {
            self.temporaryPasswordDelegate?.onHasTemporaryPassword(user)
          } else {
            self.loginDelegate?.onLoginSuccess(user)
          }
        }
      } else {

      }
    }
  }

  func updateValuesForUser(user: User) {
    let userRef = ref.childByAppendingPath("users/\(user.id)")
    userRef.observeSingleEventOfType(.Value, withBlock: {
      snapshot in
      user.updateFromSnapshot(snapshot)
    })
  }

}
