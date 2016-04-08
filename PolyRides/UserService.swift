//
//  UserService.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

protocol FirebaseUserDelegate: class {

  func onUserUpdated()
  func onUserIdReceived()

}

class UserService {

  let ref = FirebaseConnection.ref

  var delegate: FirebaseUserDelegate?

  func updateValuesForUser(user: User) {
    if let userId = user.id {
      let userRef = ref.childByAppendingPath("users/\(userId)")
      userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        user.updateFromSnapshot(snapshot)
        self.delegate?.onUserUpdated()
      })
    }
  }

  // Get the user ID of the user who logged in with Facebook. Requires Facebook ID to be present in the user.
  func getUserId(user: User) {
    let query = ref.childByAppendingPath("userMappings").childByAppendingPath(user.facebookId!)
    query.observeSingleEventOfType(.Value, withBlock: { snapshot in
      if let userId = snapshot.value as? String {
        user.id = userId
        self.delegate?.onUserIdReceived()
      } else {
        self.logOut()
      }
    })
  }

  func logOut() {
    if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
      let storyboard = UIStoryboard(name: "FacebookLogin", bundle: NSBundle.mainBundle())
      if let navVC = storyboard.instantiateInitialViewController() as? UINavigationController {
        FirebaseConnection.ref.unauth()
        appDelegate.window?.rootViewController = navVC
      }
    }
  }

  func updateProfile(user: User) {
    if let userId = user.id {
      let userRef = ref.childByAppendingPath("users/\(userId)")
      userRef.childByAppendingPath("car").setValue(user.car?.toAnyObject())
      userRef.childByAppendingPath("description").setValue(user.description)
    }
  }

}
