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

    let defaultCenter = NSNotificationCenter.defaultCenter()
    let selector = Selector("onHasTemporaryPassword:")
    let name = FirebaseConnection.TemporaryPassword
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem

    if segue.identifier == "toResetPassword" {
      if let vc = segue.destinationViewController as? ResetPasswordViewController {
        if let password = passwordTextField?.text {
          vc.temporaryPassword = password
        }
      }
    }
  }

  override func onLoginError(notification: NSNotification) {
    stopLoading("Login")
    super.onLoginError(notification)
  }

  func onHasTemporaryPassword(notification: NSNotification) {
    if let user = notification.object as? User {
      self.user = user
      self.performSegueWithIdentifier("toResetPassword", sender: self)
    }
  }

}
