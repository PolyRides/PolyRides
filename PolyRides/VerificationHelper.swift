//
//  VerificationHelper.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/1/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import SendGrid

class VerificationHelper {

  let key = "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"

  static func sendVerificationEmail(user: User, schoolEmail: String) {
    let userName = user.firstName ?? "Poly Rides User"
    let message = "<p>Hi \(userName),</p>" +
      "<p>We received your request to verify your Cal Poly email address on Poly Rides. " +
      "Please enter the code 1234 in the profile tab in the app to complete your verification.</p>" +
    "<p>Thank you,<br /> Poly Rides Team<br /> polyrides@gmail.com</p>"
    let sendGrid = SendGrid(username: "vanessaforney", password: "polyrides1")

    let email = SendGrid.Email()
    do {
      try email.addTo(schoolEmail, name: user.getFullName())
    } catch {
      print(error)
    }
    email.setFrom("polyrides@gmail.com", name: "Poly Rides App")
    email.setSubject("Verification Code for Poly Rides App")
    email.setHtmlBody(message)

    do {
      try sendGrid.send(email, completionHandler: { (response, data, error) -> Void in
        if let json = NSString(data: data!, encoding: NSUTF8StringEncoding) {
          print(json)
        }
      })
    } catch {
      print(error)
    }
  }
}
