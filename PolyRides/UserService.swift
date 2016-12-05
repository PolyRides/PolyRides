//
//  UserService.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FirebaseAuth

protocol FirebaseUserDelegate: class {

  func onUserUpdated()
  func onUserIdReceived()

}

class UserService {

  let ref = FirebaseConnection.ref

  var delegate: FirebaseUserDelegate?

  func updateValuesForUser(user: User) {
    if let userId = user.id {
      let userRef = ref.child("users/\(userId)")
      userRef.observeSingleEvent(of: .value, with: { snapshot in
        user.updateFromSnapshot(snapshot: snapshot)
        self.delegate?.onUserUpdated()
      })
    }
  }

  // Get the user ID of the user who logged in with Facebook. Requires Facebook ID to be present in the user.
  func getUserId(user: User) {
    let query = ref.child("userMappings").child(user.facebookId!)
    query.observeSingleEvent(of: .value, with: { snapshot in
      if let userId = snapshot.value as? String {
        user.id = userId
        self.delegate?.onUserIdReceived()
      } else {
        self.logOut()
      }
    })
  }

  func logOut() {
    if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
      let storyboard = UIStoryboard(name: "FacebookLogin", bundle: Bundle.main)
      if let navVC = storyboard.instantiateInitialViewController() as? UINavigationController {
        do {
          try FIRAuth.auth()?.signOut()
        } catch {
          print("Error signing out")
        }
        appDelegate.window?.rootViewController = navVC
      }
    }
  }

  func updateProfile(user: User) {
    if let userId = user.id {
      let userRef = ref.child(
        "users/\(userId)")
      userRef.child("car").setValue(user.car?.toAnyObject())
      userRef.child("description").setValue(user.description)
    }
  }

}
