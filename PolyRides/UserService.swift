//
//  UserService.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

protocol FirebaseUserDelegate: class {

  func onUserUpdated()

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

}
