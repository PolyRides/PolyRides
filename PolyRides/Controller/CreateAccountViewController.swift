//
//  CreateAccountViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class CreateAccountViewController: LoginViewController {

  @IBAction func signInAction(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(true)
  }

  @IBAction func logInWithFacebookAction(sender: AnyObject) {
    loginWithFacebook()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    trackScreen(String(CreateAccountViewController))
<<<<<<< HEAD
    buttonTitle = "Create Account"
=======
  }

  override func onLoginError(notification: NSNotification) {
    stopLoading()
    super.onLoginError(notification)
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
  }

}
