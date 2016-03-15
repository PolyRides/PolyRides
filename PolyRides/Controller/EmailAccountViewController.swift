//
//  CreateEmailAccountViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class EmailAccountViewController: LoginViewController {

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
    addTargetsForFields()
  }

  func registerForNotifications() {
    let defaultCenter = NSNotificationCenter.defaultCenter()
    var selector = Selector("onCreateAccountSuccess:")
    var name = LoginViewController.CreateAccountSuccess
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)

    selector = Selector("onLoginError:")
    name = LoginViewController.LoginError
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  func addTargetsForFields() {
    firstNameTextField?.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
    lastNameTextField?.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
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

  func onLoginError(notification: NSNotification) {
    stopLoading("Create Account")
    if let error = notification.object as? NSError {
      presentAlertForFirebaseError(error)
    }
  }

  func onCreateAccountSuccess(notification: NSNotification) {
    stopLoading("Create Account")
    let title = "Account Created Successfully"
    let message = "Please login to continue."
    presentAlert(AlertOptions(message: message, title: title, handler: toMainLogin))
  }



}
