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

enum Error {
  case EmptyEmail
  case EmptyPassword
}

class LoginViewController: UIViewController {

  static let FBErrorMessage = "An error occured while connecting to Facebook. Please try again."
  static let FBErrorTitle = "Authentication Error"

  static let ResetPasswordSuccess = "ResetPasswordSuccess"
  static let ResetPasswordError = "ResetPasswordError"

  static let ResetPasswordErrorMessage = "An error occurred while trying to reset your password."
  static let ResetPasswordErrorTitle = "Password Reset Error"

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.navigationBar.hidden = true
  }

  func onFacebookError() {
    let title = LoginViewController.FBErrorTitle
    let message = LoginViewController.FBErrorMessage
    presentAlert(AlertOptions(title: title, message: message))
  }

  func onFacebookSuccess(authData: FAuthData) {
    User(withAuthData: authData).pushToFirebase()

  }

  func presentAlertForError(error: Error) {
    var title = ""
    var message = ""
    
    switch error {
    case .EmptyEmail:
      title = "Invalid Email"
      message = "Please enter a valid email address."
    case .EmptyPassword:
      title = "Invalid Password"
      message = "Please enter a valid password."
    }

    presentAlert(AlertOptions(title: title, message: message))
  }

  func presentAlertForFirebaseError(error: NSError) {
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
        title = "No Account Found"
        message = "You must login with Facebook if you created your account with Facebook."
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

  func startMain() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    storyboard.instantiateViewControllerWithIdentifier("searchView")
  }

}
