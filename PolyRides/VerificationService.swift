//
//  VerificationService.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/2/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

protocol FirebaseVerificationDelegate {

  func onVerificationSuccessful(verification: Verification)
  func onVerificationUnsuccessful()

}

class VerificationService {

  let ref = FirebaseConnection.ref

  var delegate: FirebaseVerificationDelegate?

  func addPendingVerification(user: User, verification: Verification, code: Int) {
    if let userId = user.id {
      let verificationRef = ref.childByAppendingPath("users/\(userId)/pendingVerifications/\(verification.rawValue)")
      verificationRef.childByAppendingPath("\(code)").setValue(true)
    }
  }

  func verify(user: User, verification: Verification, enteredCode: Int) {
    if let userId = user.id {
      let userRef = ref.childByAppendingPath("users/\(userId)")
      let codeRef = userRef.childByAppendingPath("/pendingVerifications/\(verification.rawValue)/\(enteredCode)")
      codeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if snapshot.exists() {
          codeRef.removeValue()
          let verificationRef = userRef.childByAppendingPath("verifications/\(verification.rawValue)/")
          verificationRef.setValue(true)
          self.delegate?.onVerificationSuccessful(verification)
        } else {
          self.delegate?.onVerificationUnsuccessful()
        }
        })
    }
  }

}
