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
      let verificationRef = ref.child("users/\(userId)/pendingVerifications/\(verification.rawValue)")
      verificationRef.child("\(code)").setValue(true)
    }
  }

  func verify(user: User, verification: Verification, enteredCode: Int) {
    if let userId = user.id {
      let userRef = ref.child("users/\(userId)")
      let codeRef = userRef.child("/pendingVerifications/\(verification.rawValue)/\(enteredCode)")
      codeRef.observeSingleEvent(of: .value, with: { snapshot in
        if snapshot.exists() {
          codeRef.removeValue()
          let verificationRef = userRef.child("verifications/\(verification.rawValue)/")
          verificationRef.setValue(true)
          self.delegate?.onVerificationSuccessful(verification: verification)
        } else {
          self.delegate?.onVerificationUnsuccessful()
        }
        })
    }
  }

}
