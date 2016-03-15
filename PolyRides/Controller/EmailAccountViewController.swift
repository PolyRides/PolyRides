//
//  CreateEmailAccountViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class EmailAccountViewController: LoginViewController {

  let buttonTitle = "Create Account"

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

  override func onLoginError(notification: NSNotification) {
    stopLoading(buttonTitle)
    super.onLoginError(notification)
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

}
