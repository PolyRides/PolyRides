//
//  LoginService.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

protocol FirebaseLoginDelegate: class {

  func onLoginError(errorCode: FIRAuthErrorCode)
  func onLoginSuccess(user: User)

}

class AuthService {

  let ref = FIRDatabase.database().reference()

  var loginDelegate: FirebaseLoginDelegate?

  func authWithFacebook() {
    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

    FIRAuth.auth()?.signIn(with: credential) { (user, error) in
      if let error = error {
        if let errorCode = FIRAuthErrorCode(rawValue: (error._code)) {
          self.loginDelegate?.onLoginError(errorCode: errorCode)
        }
      } else {
        let query = self.ref.child("userMappings").child(user!.uid)
        query.observeSingleEvent(of: .value, with: { snapshot in
          let user = User(fromUser: user!)
          if snapshot.exists() {
            if let value = snapshot.value as? String {
              user.id = value
              self.updateUserOnFirebase(user: user)
            }
          } else {
            // New user
            let userRef = self.ref.child("users").childByAutoId()
            user.timestamp = NSDate()
            user.id = userRef.key
            self.updateUserOnFirebase(user: user)
            query.setValue(userRef.key)
          }
          self.loginDelegate?.onLoginSuccess(user: user)
        })
      }
    }
  }

  func updateUserOnFirebase(user: User) {
    if let id = user.id {
      ref.child("users/\(id)").updateChildValues(user.toAnyObject())
    }
  }

}
