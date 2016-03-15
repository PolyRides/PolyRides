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

  let buttonTitle = "Login"

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
          vc.user = user
        }
      }
    }
  }

  override func onLoginError(notification: NSNotification) {
    stopLoading(buttonTitle)
  }

  func onHasTemporaryPassword(notification: NSNotification) {
    stopLoading(buttonTitle)
    if let user = notification.object as? User {
      self.user = user
      self.performSegueWithIdentifier("toResetPassword", sender: self)
    }
  }

}
