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
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?

  @IBAction func logInWithFacebookAction(sender: AnyObject) {
    loginWithFacebook(self)
  }

  @IBAction func loginAction(sender: AnyObject) {
    loginWithEmail()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toForgotPassword" {
      let backItem = UIBarButtonItem()
      backItem.title = ""
      navigationItem.backBarButtonItem = backItem
    }
  }

  func loginWithEmail() {
    let email = emailTextField.text
    let password = passwordTextField.text

    if email == "" || !email!.isEmail() {
      presentAlertForError(Error.EmptyEmail)
    } else if password == "" {
      presentAlertForError(Error.EmptyPassword)
    } else {
      startLoading()
      FirebaseConnection.ref.authUser(email, password: password, withCompletionBlock: {
        [unowned self] error, authData in
        self.stopLoading()

        if error == nil {
          if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
            if temporaryPassword {
              // Present reset temporary password view.
            } else {
              self.startMain()
            }
          }
        } else {
            self.presentAlertForFirebaseError(error)
        }
      })
    }
  }

  func startLoading() {
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    self.loadingIndicator?.hidden = false
  }

  func stopLoading() {
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
    self.loadingIndicator?.hidden = true
  }



}
