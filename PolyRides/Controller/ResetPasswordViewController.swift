//
//  ForgotPasswordViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class ResetPasswordViewController: LoginViewController {

  // Whether or not the user logged in with a temporary password.
  var temporaryPassword = false

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var resetPasswordButton: UIButton!
  @IBOutlet weak var instructions: UILabel!

  @IBAction func resetPasswordAction(sender: AnyObject) {
    if temporaryPassword {

    } else {
      if let text = textField.text {
        User(withEmail: text).resetPassword()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Make the navigation bar transluscent.
    let metrics = UIBarMetrics.Default
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: metrics)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true

    textField.addTargetForEditing(self, selector: Selector("textFieldDidChange"))

    if !temporaryPassword {
      registerForNotifications()
    }
  }

  override func viewWillAppear(animated: Bool) {
    self.navigationController?.navigationBarHidden = false
    resetPasswordButton.enabled = false
    super.viewWillAppear(animated)

    if temporaryPassword {
      instructions.text = "You've logged in with a temporary password. Please enter a new " +
                          "password to continue."
    } else {
      instructions.text = "Enter your email address and we'll send you a link to reset your " +
                          "password."
    }
  }

  override func viewWillDisappear(animated: Bool) {
    self.navigationController?.navigationBarHidden = true
    super.viewWillDisappear(animated)
  }

  func registerForNotifications() {
    var selector = Selector("onResetPasswordSuccess:")
    NSNotificationCenter.defaultCenter().addObserver(self, selector: selector,
      name: LoginViewController.ResetPasswordSuccess, object: nil)
    selector = Selector("onResetPasswordError:")
    NSNotificationCenter.defaultCenter().addObserver(self, selector: selector,
      name: LoginViewController.ResetPasswordError, object: nil)
  }

  func textFieldDidChange() {
    let isValid = temporaryPassword ? textField.isValidPassword() : textField.isValidEmail()
    if isValid {
      resetPasswordButton.enabled = true
    } else {
      resetPasswordButton.enabled = false
    }
  }

  func onResetPasswordSuccess(notification: NSNotification) {
    print("success")
  }

  func onResetPasswordError(notification: NSNotification) {
    if let error = notification.object as? NSError {
      presentAlertForFirebaseError(error)
    }
  }

}
