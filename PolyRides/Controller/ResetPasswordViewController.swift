//
//  ForgotPasswordViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class ResetPasswordViewController: LoginViewController {

  // A user indicates the user is changing their password. A nil user is resetting their password.
  var user: User?
  var temporaryPassword: String?

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var resetPasswordButton: UIButton!
  @IBOutlet weak var instructions: UILabel!

  @IBAction func resetPasswordAction(sender: AnyObject) {
    if user == nil {
      confirmResetPassword()
    } else {
      changePassword()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    trackScreen(String(ResetPasswordViewController))

    // Make the navigation bar transluscent.
    let metrics = UIBarMetrics.Default
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: metrics)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true

    textField.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
    registerForNotifications()
  }

  override func viewWillAppear(animated: Bool) {
    self.navigationController?.navigationBarHidden = false
    resetPasswordButton.enabled = false
    super.viewWillAppear(animated)

    var text = "You've logged in with a temporary password. Please enter a new password."
    if user == nil {
      text = "Enter your email address and we'll send you a link to reset your password."
    }
    instructions.text = text
  }

  override func viewWillDisappear(animated: Bool) {
    self.navigationController?.navigationBarHidden = true
    super.viewWillDisappear(animated)
  }

  func registerForNotifications() {
    let defaultCenter = NSNotificationCenter.defaultCenter()
    var selector = Selector("onLoginError:")
    var name = LoginViewController.LoginError
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)

    selector = Selector("onResetPasswordSuccess:")
    name = LoginViewController.ResetPasswordSuccess
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)

    selector = Selector("onChangePasswordSuccess:")
    name = LoginViewController.ChangePasswordSuccess
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  func textFieldDidChange() {
    let isValid = user == nil ? textField.isValidEmail() : textField.isValidPassword()
    if isValid {
      resetPasswordButton.enabled = true
    } else {
      resetPasswordButton.enabled = false
    }
  }

  func changePassword() {
    if let user = user {
      if let temp = temporaryPassword {
        if let new = textField.text {
          FirebaseConnection.changePasswordForUser(user, temporaryPassword: temp, newPassword: new)
        }
      }
    }
  }

  func confirmResetPassword() {
    let title = "Password Reset"
    let message = "Are you sure you wish to reset your password?"
    let alertOptions = AlertOptions(message: message, title: title, handler: resetPassword,
      showCancel: true, acceptText: "Reset")
    presentAlert(alertOptions)
  }

  func resetPassword(action: UIAlertAction) {
    if let email = textField.text {
      FirebaseConnection.resetPasswordForEmail(email)
    }
  }

  func onResetPasswordSuccess(notification: NSNotification) {
    let message = "Please check your email for your temporary password."
    presentAlert(AlertOptions(message: message, title: "Password Reset Success"))
  }

  func onChangePasswordSuccess(notification: NSNotification) {
    startMain(user)
  }

  func onLoginError(notification: NSNotification) {
    if let error = notification.object as? NSError {
      presentAlertForFirebaseError(error)
    }
  }



}
