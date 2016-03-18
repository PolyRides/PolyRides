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

  let buttonTitle = "Reset Password"

  var temporaryPassword = ""

  @IBOutlet weak var instructions: UILabel!
  @IBOutlet weak var textField: UITextField!

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
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: metrics)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true

    if temporaryPassword != "" {
      textField.secureTextEntry = true
    }

    textField.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
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

  override func addObservers() {
    super.addObservers()

    let defaultCenter = NSNotificationCenter.defaultCenter()
    var selector = Selector("onResetPasswordSuccess:")
    var name = FirebaseConnection.ResetPasswordSuccess
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)

    selector = Selector("onChangePasswordSuccess:")
    name = FirebaseConnection.ChangePasswordSuccess
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  override func removeObservers() {
    let defaultCenter = NSNotificationCenter.defaultCenter()
    var name = FirebaseConnection.ResetPasswordSuccess
    defaultCenter.removeObserver(self, name: name, object: nil)

    name = FirebaseConnection.ChangePasswordSuccess
    defaultCenter.removeObserver(self, name: name, object: nil)

    super.removeObservers()
  }

  override func onLoginError(notification: NSNotification) {
    stopLoading("Reset Password")
    super.onLoginError(notification)
  }

  override func textFieldDidChange() {
    let isValid = temporaryPassword == "" ? textField.isValidEmail() : textField.isValidPassword()
    if isValid {
      button?.enabled = true
    } else {
      button?.enabled = false
    }
  }

  func changePassword() {
    if let user = user {
      if let new = textField.text {
        startLoading()
        let temp = temporaryPassword
        FirebaseConnection.changePasswordForUser(user, temporaryPassword: temp, newPassword: new)
      }
    }
  }

  func resetPassword(action: UIAlertAction) {
    startLoading()
    if let email = textField.text {
      FirebaseConnection.resetPasswordForEmail(email)
    }
  }

  func confirmResetPassword() {
    let title = "Password Reset"
    let message = "Are you sure you wish to reset your password?"
    let alertOptions = AlertOptions(message: message, title: title, handler: resetPassword,
      showCancel: true, acceptText: "Reset")
    presentAlert(alertOptions)
  }

  func onResetPasswordSuccess(notification: NSNotification) {
    stopLoading(buttonTitle)
    let title = "Password Successfully Reset"
    let message = "Please check your email for your temporary password."
    presentAlert(AlertOptions(message: message, title: title, handler: onPasswordReset))
  }

  func onChangePasswordSuccess(notification: NSNotification) {
    stopLoading(buttonTitle)
    startMain()
  }

  func onPasswordReset(alert: UIAlertAction) {
    if let navigationController = navigationController {
      if let vc = navigationController.viewControllers.first as? MainLoginViewController {
        if let email = textField?.text {
          vc.emailTextField?.text = email
        }
      }
      navigationController.popViewControllerAnimated(true)
    }
  }

}
