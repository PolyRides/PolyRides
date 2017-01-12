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
    presentAlert(alertOptions: options)
  }

  @IBAction func cancelButtonAction(sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func saveButtonAction(sender: AnyObject) {
    user?.car = Car(make: makeLabel?.text, model: modelLabel?.text, year: yearLabel?.text, color: colorLabel?.text)
    if descriptionTextView?.text != emptyDescription {
      user?.description = descriptionTextView?.text
    }
    if let user = user {
      userService.updateProfile(user: user)
      delegate?.onProfileSaved()
    }
    dismiss(animated: true, completion: nil)
  }

  @IBAction func verifyEmailAction(sender: AnyObject) {
    let title = "Verify Email"
    let message = "Enter your Cal Poly email address ending in @calpoly.edu."
    let options = AlertOptions(message: message, title: title, acceptText: "Send", handler: onSendVerification,
                               showCancel: true, configurationHandler: addVerificationHandler)
    presentAlert(alertOptions: options)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupAppearance()
    verificationService.delegate = self
    descriptionTextView?.text = user?.description ?? emptyDescription
    makeLabel?.text = user?.car?.make
    modelLabel?.text = user?.car?.model
    colorLabel?.text = user?.car?.color
    descriptionTextView?.delegate = self


    if descriptionTextView?.text == emptyDescription {
      descriptionTextView?.textColor = UIColor.lightGray
    } else if descriptionTextView?.text == "" {
      descriptionTextView?.text = emptyDescription
      descriptionTextView?.textColor = UIColor.lightGray
    } else {
      descriptionTextView?.textColor = UIColor.black
    }

    if let year = user?.car?.year {
      yearLabel?.text = "\(year)"
    }

    if user?.verifications.index(of: Verification.CalPoly) != nil {
      verifiedImage?.setImage(Verification.CalPoly.getVerifiedImage(), for: .normal)
      verifiedImage?.isUserInteractionEnabled = false
      verifiedImage?.isHidden = false
      verifyButton?.isHidden = true
    } else if user?.pendingVerifications.index(of: Verification.CalPoly) != nil {
      verifiedImage?.setImage(Verification.CalPoly.getUnverifiedImage(), for: .normal)
      verifiedImage?.isHidden = false
      verifyButton?.isHidden = true
    }
  }

  func addVerificationHandler(textField: UITextField?) {
    self.verificationCodeField = textField
  }

  func onSendVerification(alert: UIAlertAction) {
    if let user = user {
      if let email = verificationCodeField?.text {
        if let verification = Verification.getVerification(email: email) {
          sendVerificationEmail(user: user, verification: verification, email: email)
        } else {
          let title = "Invalid Email"
          let message = "Please enter a valid Cal Poly email."
          self.presentAlert(alertOptions: AlertOptions(message: message, title: title))
        }
      }
    }
  }

  func onCodeEntered(alert: UIAlertAction) {
    if let user = user {
      if let codeString = verificationCodeField?.text {
        if let code = Int(codeString) {
          verificationService.verify(user: user, verification: Verification.CalPoly, enteredCode: code)
        }
      }
    }
  }

  func sendVerificationEmail(user: User, verification: Verification, email schoolEmail: String) {
    let code = Int(arc4random_uniform(10000))

    let address = Address(email: schoolEmail, name: user.getFullName())
    let personalization = Personalization(to: [address])
    let userName = user.firstName ?? "Poly Rides User"
    let content = Content(contentType: ContentType.htmlText, value: "<p>Hi \(userName),</p>" +
      "<p>We received your request to verify your Cal Poly email address on Poly Rides. " +
      "Please enter the code \(code) in the profile tab in the app to complete your verification.</p>" +
      "<p>Thank you,<br /> Poly Rides Team<br /> polyrides@gmail.com</p>")
    let email = Email(
      personalizations: [personalization],
      from: Address(email: "polyrides@gmail.com", name: "Poly Rides App"),
      content: [content],
      subject: "Verification Code for Poly Rides App"
    )

    do {
      try Session.shared.send(request: email)
      self.verificationService.addPendingVerification(user: user, verification: verification, code: code)

      let message = "Please check your email for a verification code."
      let title = "Email Sent"
      DispatchQueue.main.async(execute: { [weak self] in
        self?.presentAlert(alertOptions: AlertOptions(message: message, title: title))
        self?.verifyButton?.isHidden = true
        self?.verifiedImage?.setImage(Verification.CalPoly.getUnverifiedImage(), for: .normal)
        self?.verifiedImage?.isHidden = false
      })
    } catch {
      let title = "Error Sending Email"
      let message = "Please try again."
      DispatchQueue.main.async(execute: { [weak self] in
        self?.presentAlert(alertOptions: AlertOptions(message: message, title: title))
      })
    }
  }

}

// MARK: - FirebaseVerificationDelegate
extension EditProfileViewController: FirebaseVerificationDelegate {

  func onVerificationSuccessful(verification: Verification) {
    let title = "Verification Successful"
    DispatchQueue.main.async(execute: {
      self.presentAlert(alertOptions: AlertOptions(message: "", title: title))
    })

    verifyButton?.isHidden = true
    self.verifiedImage?.setImage(Verification.CalPoly.getVerifiedImage(), for: .normal)
    verifiedImage?.isUserInteractionEnabled = false
  }

  func onVerificationUnsuccessful() {
    let message = "The code you have entered does not match our records."
    let title = "Verification Error"
    DispatchQueue.main.async(execute: {
      self.presentAlert(alertOptions: AlertOptions(message: message, title: title))
    })
  }
}

extension EditProfileViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    print (textView.textColor!)
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = emptyDescription
      textView.textColor = UIColor.lightGray
    }
  }
}
