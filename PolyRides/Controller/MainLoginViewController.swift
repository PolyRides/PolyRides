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

<<<<<<< HEAD
=======
  let buttonTitle = "Login"

>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
  @IBAction func logInWithFacebookAction(sender: AnyObject) {
    loginWithFacebook()
  }

  @IBAction func loginAction(sender: AnyObject) {
    startLoading()
    loginWithEmail()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    trackScreen(String(MainLoginViewController))
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem

    if segue.identifier == "toResetPassword" {
      if let vc = segue.destinationViewController as? ResetPasswordViewController {
        vc.user = user
<<<<<<< HEAD
        if let password = passwordTextField?.text {
          vc.temporaryPassword = password
=======
        if let sender = sender as? String {
          if sender == FirebaseConnection.TemporaryPassword {
            if let password = passwordTextField?.text {
                vc.temporaryPassword = password
            }
          }
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
        }
      }
    }
  }

<<<<<<< HEAD
=======
  override func addObservers() {
    super.addObservers()

    let defaultCenter = NSNotificationCenter.defaultCenter()
    let selector = Selector("onHasTemporaryPassword:")
    let name = FirebaseConnection.TemporaryPassword
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  override func removeObservers() {
    super.removeObservers()

    let defaultCenter = NSNotificationCenter.defaultCenter()
    let name = FirebaseConnection.TemporaryPassword
    defaultCenter.removeObserver(self, name: name, object: nil)
  }

  override func onLoginError(notification: NSNotification) {
    stopLoading(buttonTitle)
    super.onLoginError(notification)
  }

  func onHasTemporaryPassword(notification: NSNotification) {
    stopLoading(buttonTitle)
    if let user = notification.object as? User {
      self.user = user
      let temporaryPassword = FirebaseConnection.TemporaryPassword
      self.performSegueWithIdentifier("toResetPassword", sender: temporaryPassword)
    }
  }

>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
}
