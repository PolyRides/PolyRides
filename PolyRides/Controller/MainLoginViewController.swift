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

  var user: User?

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var loginButton: UIButton!

  @IBAction func logInWithFacebookAction(sender: AnyObject) {
    loginWithFacebook(self)
  }

  @IBAction func loginAction(sender: AnyObject) {
    startLoading(loginButton, indicator: loadingIndicator)
    loginWithEmail()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    trackScreen(String(MainLoginViewController))

    emailTextField.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
    passwordTextField.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // stopLoading(loginButton, indicator: loadingIndicator, title: "Login")
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem

    if segue.identifier == "toResetPassword" {
      if let vc = segue.destinationViewController as? ResetPasswordViewController {
          vc.user = user
          vc.temporaryPassword = passwordTextField.text
      }
    }
  }

  func textFieldDidChange() {
    if emailTextField.isValidEmail() && passwordTextField.isValidPassword() {
      loginButton.enabled = true
    } else {
      loginButton.enabled = false
    }
  }

}
