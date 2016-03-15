//
//  FBLoginViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase
import FBSDKLoginKit

class FBLoginViewController: UIViewController {

  static let LoginErrorMessage = "An error occured while connecting to Facebook. Please try again."
  static let LoginErrorTitle = "Authentication Error"

  func loginWithFacebook(viewController: UIViewController) {
    let facebookLogin = FBSDKLoginManager()
    facebookLogin.logInWithReadPermissions(["email"], fromViewController: viewController, handler: {
      (facebookResult, facebookError) -> Void in
      if facebookError != nil {
        self.onFacebookError()
      } else if facebookResult.isCancelled {
        print("Facebook log in was cancelled.")
      } else {
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        FirebaseConnection.ref.authWithOAuthProvider("facebook", token: accessToken,
          withCompletionBlock: { error, authData in
            if error != nil {
              self.onFacebookError()
            } else {
              self.onFacebookSuccess(authData)
            }
        })
      }
    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.navigationBar.hidden = true
  }

  func onFacebookError() {
    let title = FBLoginViewController.LoginErrorTitle
    let message = FBLoginViewController.LoginErrorMessage
    presentAlert(AlertOptions(title: title, message: message))
  }

  func onFacebookSuccess(authData: FAuthData) {
    User(withAuthData: authData).pushToFirebase()
  }

}
