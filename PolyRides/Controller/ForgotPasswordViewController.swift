//
//  ForgotPasswordViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class ForgotPasswordViewController: LoginViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var resetPasswordButton: UIButton!

  @IBAction func resetPasswordAction(sender: AnyObject) {
    if let email = emailTextField.text {
      User(withEmail: email).resetPassword()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Make the navigation bar transluscent.
    let metrics = UIBarMetrics.Default
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: metrics)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true

    emailTextField.addTarget(self, action: Selector("emailTextFieldDidChange"),
      forControlEvents: UIControlEvents.EditingChanged)

    registerForNotifications()
  }

  override func viewWillAppear(animated: Bool) {
    self.navigationController?.navigationBarHidden = false
    resetPasswordButton.enabled = false
    super.viewWillAppear(animated)
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

  func emailTextFieldDidChange() {
    var resetPassword = false
    if let email = emailTextField.text {
      if email.isEmail() == true {
        resetPassword = true
      }
    }
    resetPasswordButton.enabled = resetPassword
  }

  func onResetPasswordSuccess(notification: NSNotification) {
    print("success")
  }

  func onResetPasswordError(notification: NSNotification) {
    if let error = notification.object as? NSError {
      presentAlertForError(error)
    }
  }

}
