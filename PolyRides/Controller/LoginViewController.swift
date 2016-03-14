//
//  LoginViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

//
//  FBLoginViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {

  static let FBLoginErrorMessage = "An error occured while connecting to Facebook." +
                                   "Please try again."
  static let FBLoginErrorTitle = "Authentication Error"

  static let ResetPasswordSuccess = "ResetPasswordSuccess"
  static let ResetPasswordError = "ResetPasswordError"

  static let ResetPasswordErrorMessage = "An error occurred while trying to reset your password."
  static let ResetPasswordErrorTitle = "Password Reset Error"

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
    let title = LoginViewController.FBLoginErrorTitle
    let message = LoginViewController.FBLoginErrorMessage
    presentAlert(AlertOptions(title: title, message: message))
  }

  func onFacebookSuccess(authData: FAuthData) {
    User(withAuthData: authData).pushToFirebase()

  }

  func presentAlertForError(error: NSError) {
    if let errorCode = FAuthenticationError(rawValue: error.code) {
      var title = ""
      var message = ""
      switch errorCode {
      case .EmailTaken:
        title = "Email Taken"
        message = "An account with that email address already exists."
      case .InvalidEmail:
        title = "Invalid Email"
        message = "Please enter a valid email address."
      case .InvalidArguments:
        title = "Invalid Arguments"
        message = "The specified credentials are incomplete."
      case .InvalidCredentials:
        title = "Invalid Credentials"
        message = "The specified authentication credentials are invalid."
      case .InvalidPassword:
        title = "Incorrect Password"
        message = "The password you entered does not match our records."
      case .UserDoesNotExist:
        title = "User Does Not Exist"
        message = "Use the Facebook button to log in if you created your account with Facebook."
      case .NetworkError:
        title = "Network Error"
        message = "An error occurred while trying to login"
      default:
        title = "Error"
        message = "There was an error loggin in. Please try again."
      }

      presentAlert(AlertOptions(title: title, message: message))
    }
  }

}
