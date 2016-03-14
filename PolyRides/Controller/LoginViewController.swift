//
//  ViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/11/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class LoginViewController: GAITrackedViewController {

  @IBOutlet weak var emailTextField: NSLayoutConstraint!
  @IBOutlet weak var passwordTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    GoogleAnalyticsHelper.trackScreen(String(LoginViewController))
  }

}
