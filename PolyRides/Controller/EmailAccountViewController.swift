//
//  CreateEmailAccountViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class EmailAccountViewController: LoginViewController {

  @IBOutlet weak var firstNameTextField: UITextField?
  @IBOutlet weak var lastNameTextField: UITextField?

  @IBAction func signInAction(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(true)
  }

  @IBAction func creatAccountAction(sender: AnyObject) {
    createAccount()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    trackScreen(String(EmailAccountViewController))
    registerForNotifications()
  }

  override func registerForNotifications() {
    super.registerForNotifications()

    let defaultCenter = NSNotificationCenter.defaultCenter()
    let selector = Selector("onCreateAccountSuccess:")
    let name = FirebaseConnection.CreateAccountSuccess
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  override func onLoginError(notification: NSNotification) {
    stopLoading("Create Account")
    super.onLoginError(notification)
  }

  override func textFieldDidChange() {
    let empty = firstNameTextField?.text == "" || lastNameTextField?.text == ""
    let invalidEmail = emailTextField?.isValidEmail() == false
    let invalidPassword = passwordTextField?.isValidPassword() == false
    if !invalidEmail && !invalidPassword && !empty {
      button?.enabled = true
    } else {
      button?.enabled = false
    }
  }

  func createAccount() {
    if let email = emailTextField?.text {
      if let password = passwordTextField?.text {
        if let firstName = firstNameTextField?.text {
          if let lastName = lastNameTextField?.text {
            startLoading()
            let user = User(email: email, firstName: firstName, lastName: lastName)
            FirebaseConnection.createUser(user, password: password)
          }
        }
      }
    }
  }

  func onCreateAccountSuccess(notification: NSNotification) {
    stopLoading("Create Account")
    let title = "Account Created Successfully"
    let message = "Please login to continue."
    presentAlert(AlertOptions(message: message, title: title, handler: startMain))
  }

}
