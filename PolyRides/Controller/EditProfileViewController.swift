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
  let verificationService = VerificationService()

  var delegate: EditProfileDelegate?
  var user: User?

  @IBOutlet weak var makeLabel: UITextField?
  @IBOutlet weak var modelLabel: UITextField?
  @IBOutlet weak var yearLabel: UITextField?
  @IBOutlet weak var colorLabel: UITextField?
  @IBOutlet weak var descriptionTextView: UITextView?
  @IBOutlet weak var verificationCodeField: UITextField?
  @IBOutlet weak var verifyButton: UIButton?
  @IBOutlet weak var verifiedImage: UIButton?

  @IBAction func verifyButtonAction(sender: AnyObject) {
    // action sheet: Enter Code, Resend Email, Remove
    let title = "Enter Code"
    let message = "Enter the code sent to your Cal Poly email address."
    let options = AlertOptions(message: message, title: title, acceptText: "Submit", handler: onCodeEntered,
                               showCancel: true, configurationHandler: addVerificationHandler)
    presentAlert(options)
  }

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

    setupAppearance()
    verificationService.delegate = self
    descriptionTextView?.text = user?.description ?? emptyDescription
    makeLabel?.text = user?.car?.make
    modelLabel?.text = user?.car?.model
    colorLabel?.text = user?.car?.color

    if let year = user?.car?.year {
      yearLabel?.text = "\(year)"
    }

    if user?.verifications.indexOf(Verification.CalPoly) != nil {
      verifiedImage?.setImage(Verification.CalPoly.getVerifiedImage(), forState: .Normal)
      verifiedImage?.userInteractionEnabled = false
      verifiedImage?.hidden = false
      verifyButton?.hidden = true
    } else if user?.pendingVerifications.indexOf(Verification.CalPoly) != nil {
      verifiedImage?.setImage(Verification.CalPoly.getUnverifiedImage(), forState: .Normal)
      verifiedImage?.hidden = false
      verifyButton?.hidden = true
    }
  }

  func addVerificationHandler(textField: UITextField!) {
    self.verificationCodeField = textField
  }

  func onSendVerification(alert: UIAlertAction) {
    if let user = user {
      if let email = verificationCodeField?.text {
        if let verification = Verification.getVerification(email) {
          sendVerificationEmail(user, verification: verification, email: email)
        } else {
          let title = "Invalid Email"
          let message = "Please enter a valid Cal Poly email."
          self.presentAlert(AlertOptions(message: message, title: title))
        }
      }
    }
  }

  func onCodeEntered(alert: UIAlertAction) {
    if let user = user {
      if let codeString = verificationCodeField?.text {
        if let code = Int(codeString) {
          verificationService.verify(user, verification: Verification.CalPoly, enteredCode: code)
        }
      }
    }
  }

  func sendVerificationEmail(user: User, verification: Verification, email schoolEmail: String) {
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
          self.verificationService.addPendingVerification(user, verification: verification, code: code)

          let message = "Please check your email for a verification code."
          let title = "Email Sent"
          dispatch_async(dispatch_get_main_queue(), {
            self.presentAlert(AlertOptions(message: message, title: title))
            self.verifyButton?.hidden = true
            self.verifiedImage?.setImage(Verification.CalPoly.getUnverifiedImage(), forState: .Normal)
            self.verifiedImage?.hidden = false
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

// MARK: - FirebaseVerificationDelegate
extension EditProfileViewController: FirebaseVerificationDelegate {

  func onVerificationSuccessful(verification: Verification) {
    let title = "Verification Successful"
    dispatch_async(dispatch_get_main_queue(), {
      self.presentAlert(AlertOptions(message: "", title: title))
    })

    verifyButton?.hidden = true
    self.verifiedImage?.setImage(Verification.CalPoly.getVerifiedImage(), forState: .Normal)
    verifiedImage?.userInteractionEnabled = false
  }

  func onVerificationUnsuccessful() {
    let message = "The code you have entered does not match our records."
    let title = "Verification Error"
    dispatch_async(dispatch_get_main_queue(), {
      self.presentAlert(AlertOptions(message: message, title: title))
    })
  }

}
