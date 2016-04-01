//
//  ForgotPasswordViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

// Used for resetting a users password, which can be changing the password from an email address
// or resetting the password because it was a temporary password. Determined by if the user is nil.
class ResetPasswordViewController: LoginViewController {

  var temporaryPassword = ""

  @IBOutlet weak var instructions: UILabel!

  @IBAction func resetPasswordAction(sender: AnyObject) {
    if temporaryPassword == "" {
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
    navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: metrics)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.translucent = true

    if temporaryPassword != "" {
      passwordTextField?.secureTextEntry = true
      passwordTextField?.delegate = self
    } else {
      authService.resetPasswordDelegate = self
      emailTextField?.delegate = self
    }

    passwordTextField?.addTargetForEditing(self, selector: #selector(LoginViewController.textFieldDidChange))
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBarHidden = false
    var text = "You've logged in with a temporary password. Please enter a new password."
    if temporaryPassword == "" {
      text = "Enter your email address and we'll send you a link to reset your password."
    }
    instructions.text = text
  }

  override func textFieldDidChange() {
    if let isValid = temporaryPassword == "" ? emailTextField?.isValidEmail() : passwordTextField?.isValidPassword() {
      if isValid {
        button?.enabled = true
      } else {
        button?.enabled = false
      }
    }
  }

  func changePassword() {
    if let user = user {
      if let new = passwordTextField?.text {
        startLoading()
        let temp = temporaryPassword
        authService.changePasswordForUser(user, temporaryPassword: temp, newPassword: new)
      }
    }
  }

  func resetPassword(action: UIAlertAction) {
    startLoading()
    if let email = emailTextField?.text {
      authService.resetPasswordForEmail(email)
    }
  }

  func confirmResetPassword() {
    let title = "Password Reset"
    let message = "Are you sure you wish to reset your password?"
    let alertOptions = AlertOptions(message: message, title: title, handler: resetPassword,
      showCancel: true, acceptText: "Reset")
    presentAlert(alertOptions)
  }

}

// MARK: - FirebaseResetPasswordDelegate
extension ResetPasswordViewController: FirebaseResetPasswordDelegate {

  func onPasswordResetSuccess(email: String) {
    stopLoading()
    let title = "Password Successfully Reset"
    let message = "Please check your email for your temporary password."
    presentAlert(AlertOptions(message: message, title: title, handler: onPasswordReset))
  }

}

// MARK: - UITextFieldDelegate
extension ResetPasswordViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    resetPasswordAction(textField)
    return true
  }

}
