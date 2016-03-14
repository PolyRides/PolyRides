//
//  CreateEmailAccountViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class EmailAccountViewController: LoginViewController {

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  @IBOutlet weak var createAccountButton: UIButton!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

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

  func registerForNotifications() {
    let defaultCenter = NSNotificationCenter.defaultCenter()
    var selector = Selector("onCreateAccountSuccess:")
    var name = LoginViewController.CreateAccountSuccess
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)

    selector = Selector("onLoginError:")
    name = LoginViewController.LoginError
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  func createAccount() {
    if let email = emailTextField.text {
      if let password = passwordTextField.text {
        if let firstName = firstNameTextField.text {
          if let lastName = lastNameTextField.text {
            startLoading(createAccountButton, indicator: loadingIndicator)
            let user = User(email: email, firstName: firstName, lastName: lastName)
            FirebaseConnection.createUser(user, password: password)
          }
        }
      }
    }
  }

  func onLoginError(notification: NSNotification) {
    if let error = notification.object as? NSError {
      presentAlertForFirebaseError(error)
    }
  }

  func onCreateAccountSuccess() {
    let title = "Account Created Successfully"
    let message = "Please login to continue."
    presentAlert(AlertOptions(message: message, title: title, handler: toMainLogin))
  }

  func toMainLogin(action: UIAlertAction) {
    if let navigationController = navigationController {
      if let vc = navigationController.topViewController as? MainLoginViewController {
        if let email = emailTextField.text {
          if let password = passwordTextField.text {
            vc.emailTextField.text = email
            vc.passwordTextField.text = password
            navigationController.popToRootViewControllerAnimated(true)
          }
        }
      }
    }
  }

}
