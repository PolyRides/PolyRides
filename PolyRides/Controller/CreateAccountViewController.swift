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
    loginWithFacebook(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.navigationBar.hidden = false
    trackScreen(String(CreateAccountViewController))
  }

}
