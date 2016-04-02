//
//  EditProfileViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/1/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import SendGrid

protocol EditProfileDelegate: class {

  func onProfileSaved()

}

class EditProfileViewController: UIViewController {

  let key = "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"
  let emptyDescription = "Enter a short description about yourself."
  let userService = UserService()

  var delegate: EditProfileDelegate?
  var user: User?

  @IBOutlet weak var makeLabel: UITextField?
  @IBOutlet weak var modelLabel: UITextField?
  @IBOutlet weak var yearLabel: UITextField?
  @IBOutlet weak var colorLabel: UITextField?
  @IBOutlet weak var descriptionTextView: UITextView?
  @IBOutlet weak var verificationCodeField: UITextField?

  @IBAction func cancelButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func saveButtonAction(sender: AnyObject) {
    user?.car = Car(make: makeLabel?.text, model: modelLabel?.text, year: yearLabel?.text, color: colorLabel?.text)
    if descriptionTextView?.text != emptyDescription {
      user?.description = descriptionTextView?.text
    }
    if let user = user {
      userService.updateProfile(user)
      delegate?.onProfileSaved()
    }
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func verifyEmailAction(sender: AnyObject) {
    let title = "Verify Email"
    let message = "Enter your Cal Poly email address ending in @calpoly.edu."
    let options = AlertOptions(message: message, title: title, acceptText: "Send", handler: onSendVerification,
                               showCancel: true, configurationHandler: addVerificationHandler)
    presentAlert(options)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    descriptionTextView?.text = user?.description ?? emptyDescription
    makeLabel?.text = user?.car?.make
    modelLabel?.text = user?.car?.model
    colorLabel?.text = user?.car?.color

    if let year = user?.car?.year {
      yearLabel?.text = "\(year)"
    }
  }

  func addVerificationHandler(textField: UITextField!) {
    self.verificationCodeField = textField
  }

  func onSendVerification(alert: UIAlertAction) {
    if let user = user {
      if let email = verificationCodeField?.text {
        if email.hasSuffix("@calpoly.edu") {
          sendVerificationEmail(user, schoolEmail: email)
        } else {
          let title = "Invalid Email"
          let message = "Please enter a valid Cal Poly email."
          self.presentAlert(AlertOptions(message: message, title: title))
        }
      }
    }
  }

  func sendVerificationEmail(user: User, schoolEmail: String) {
    let code = Int(arc4random_uniform(10000))
    let userName = user.firstName ?? "Poly Rides User"
    let message = "<p>Hi \(userName),</p>" +
      "<p>We received your request to verify your Cal Poly email address on Poly Rides. " +
      "Please enter the code \(code) in the profile tab in the app to complete your verification.</p>" +
    "<p>Thank you,<br /> Poly Rides Team<br /> polyrides@gmail.com</p>"
    let sendGrid = SendGrid(username: "vanessaforney", password: "polyrides1")

    let email = SendGrid.Email()
    do {
      try email.addTo(schoolEmail, name: user.getFullName())
    } catch {
      let title = "Error Sending Email"
      let message = "Please try again."
      dispatch_async(dispatch_get_main_queue(), {
        self.presentAlert(AlertOptions(message: message, title: title))
      })
      return
    }
    email.setFrom("polyrides@gmail.com", name: "Poly Rides App")
    email.setSubject("Verification Code for Poly Rides App")
    email.setHtmlBody(message)

    do {
      try sendGrid.send(email, completionHandler: { (response, data, error) -> Void in
        if error == nil {
          let message = "Please check your email for a verification code."
          let title = "Success"
          dispatch_async(dispatch_get_main_queue(), {
            self.presentAlert(AlertOptions(message: message, title: title))
          })
        }
      })
    } catch {
      let title = "Error Sending Email"
      let message = "Please try again."
      dispatch_async(dispatch_get_main_queue(), {
        self.presentAlert(AlertOptions(message: message, title: title))
      })
    }
  }

}
