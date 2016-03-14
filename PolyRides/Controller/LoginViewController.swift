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

  static let FBErrorMessage = "An error occured while connecting to Facebook. Please try again."
  static let FBErrorTitle = "Authentication Error"

  static let ChangePasswordSuccess = "ChangePasswordSuccess"
  static let ResetPasswordSuccess = "ResetPasswordSuccess"
  static let CreateAccountSuccess = "CreateAccountSuccess"
  static let LoginError = "LoginError"

  func startLoading(button: UIButton, indicator: UIActivityIndicatorView) {
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    button.setTitle("", forState: UIControlState.Normal)
    indicator.startAnimating()
  }

  func stopLoading((button: UIButton, indicator: UIActivityIndicatorView, title: String) {
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
    self.indicator.stopAnimating()
    button.setTitle(title, forState: UIControlState.Normal)
  }

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
    let user = User(withAuthData: authData)
    user.pushToFirebase()
    startMain(user)
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
    facebookLogin.logInWithReadPermissions(["email"], fromViewController: viewController) {
      (facebookResult, facebookError) -> Void in
      if facebookError != nil {
        self.onFacebookError()
      } else if facebookResult.isCancelled {
        print("Facebook log in was cancelled.")
        // Do nothing.
      } else {
        let token = FBSDKAccessToken.currentAccessToken().tokenString
        FirebaseConnection.ref.authWithOAuthProvider("facebook", token: token) { error, authData in
            if error != nil {
              self.onFacebookError()
            } else {
              self.onFacebookSuccess(authData)
            }
        }
      }
    }
  }

  func loginWithEmail() {
    let email = emailTextField.text
    let password = passwordTextField.text

    FirebaseConnection.ref.authUser(email, password: password) { error, authData in

      if error == nil {
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          self.user = User(withAuthData: authData)
          if temporaryPassword {
            self.performSegueWithIdentifier("toResetPassword", sender: self)
          } else {
            self.startMain(self.user)
          }
        }
      } else {
        self.presentAlertForFirebaseError(error)
      }
    }
  }

  func startMain(user: User?) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewControllerWithIdentifier("search")
    if let searchViewcontroller = viewController as? SearchTableViewController {
      searchViewcontroller.user = user
      if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
        appDelegate.window?.rootViewController = searchViewcontroller
      }
    }
  }

}
