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

}
