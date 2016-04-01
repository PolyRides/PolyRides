//
//  LoginService.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FBSDKLoginKit

protocol FirebaseLoginDelegate: class {

  func onLoginError(error: NSError)
  func onLoginSuccess(user: User)
  func onHasTemporaryPassword(user: User)

}

protocol FirebaseResetPasswordDelegate: class {

  func onPasswordResetSuccess(email: String)

}

class AuthService {

  let ref = FirebaseConnection.ref

  var loginDelegate: FirebaseLoginDelegate?
  var resetPasswordDelegate: FirebaseResetPasswordDelegate?

  func resetPasswordForEmail(email: String) {
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
          user.timestamp = NSDate()
          self.updateUserOnFirebase(user)
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
        let query = self.ref.childByAppendingPath("userMappings").childByAppendingPath(authData.uid)
        query.observeSingleEventOfType(.Value, withBlock: { snapshot in
          let user = User(fromAuthData: authData)
          if snapshot.exists() {
            if let value = snapshot.value as? String {
              user.id = value
              self.updateUserOnFirebase(user)
            }
          } else {
            // New user
            let userRef = self.ref.childByAppendingPath("users").childByAutoId()
            user.timestamp = NSDate()
            user.id = userRef.key
            self.updateUserOnFirebase(user)
            query.setValue(userRef.key)
          }
          self.loginDelegate?.onLoginSuccess(user)
        })
      } else {
        self.loginDelegate?.onLoginError(error)
      }
    }
  }

  func authUser(email: String, password: String) {
    ref.authUser(email, password: password) { error, authData in
      if error == nil {
        let user = User(fromAuthData: authData)
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          if temporaryPassword {
            self.loginDelegate?.onHasTemporaryPassword(user)
          } else {
            self.loginDelegate?.onLoginSuccess(user)
          }
        } else {
          self.loginDelegate?.onLoginSuccess(user)
        }
      } else {
        self.loginDelegate?.onLoginError(error)
      }
    }
  }

  func updateUserOnFirebase(user: User) {
    if let id = user.id {
      ref.childByAppendingPath("users/\(id)").updateChildValues(user.toAnyObject())
    }
  }

}
