//
//  FBLoginViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase
import FBSDKLoginKit

class MainLoginViewController: LoginViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var loginButton: UIButton!

  @IBAction func logInWithFacebookAction(sender: AnyObject) {
    loginWithFacebook(self)
  }

  @IBAction func loginAction(sender: AnyObject) {
    loginWithEmail()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    emailTextField.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
    passwordTextField.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem

    if segue.identifier == "toResetPassword" {
      if let temporaryPassword = sender?.object as? Bool {
        if temporaryPassword {
          if let vc = segue.destinationViewController as? ResetPasswordViewController {
            vc.temporaryPassword = true
          }
        }
      }

    }
  }

  func loginWithEmail() {
    let email = emailTextField.text
    let password = passwordTextField.text

    startLoading()
    FirebaseConnection.ref.authUser(email, password: password, withCompletionBlock: {
      [unowned self] error, authData in
      self.stopLoading()

      if error == nil {
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          if temporaryPassword {
            self.performSegueWithIdentifier("toResetPassword", sender: temporaryPassword)
          } else {
            self.startMain()
          }
        }
      } else {
        self.presentAlertForFirebaseError(error)
      }
      })
  }

  func startLoading() {
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    loginButton.setTitle("", forState: UIControlState.Normal)
    loadingIndicator.startAnimating()
  }

  func stopLoading() {
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
    self.loadingIndicator.stopAnimating()
    loginButton.setTitle("Login", forState: UIControlState.Normal)
  }

  func textFieldDidChange() {
    if emailTextField.isValidEmail() && passwordTextField.isValidPassword() {
      loginButton.enabled = true
    } else {
      loginButton.enabled = false
    }
  }

}
