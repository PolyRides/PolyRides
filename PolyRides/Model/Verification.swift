//
//  Verification.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/2/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

enum Verification: String {
  case CalPoly

  static let allVerifications = [CalPoly]

  static let verificationNames = [
    CalPoly: "Cal Poly"
  ]
  static let verificationImages = [
    CalPoly: "calpoly"
  ]
  static let extensionToVerifications = [
    "@calpoly.edu": CalPoly
  ]

  func name() -> String {
    return Verification.verificationNames[self]!
  }

  func image() -> UIImage {
    return UIImage(named: Verification.verificationImages[self]!)!
  }

  static func getVerification(email: String) -> Verification? {
    for extensionToVerification in extensionToVerifications {
      if email.hasSuffix(extensionToVerification.0) {
        return extensionToVerification.1
      }
    }
    return nil
  }

}
