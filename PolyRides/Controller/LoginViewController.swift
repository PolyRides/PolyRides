//
//  LoginViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase
import FBSDKLoginKit

class LoginViewController: LoadingViewController {

  let authService = AuthService()

  @IBOutlet weak var indicator: UIActivityIndicatorView?
  @IBOutlet weak var button: UIButton?
  @IBOutlet weak var buttonView: UIView?

  @IBAction func logInWithFacebookAction(sender: AnyObject) {
    startLoading()
    loginWithFacebook()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    authService.loginDelegate = self

    // user is logged in
    if FBSDKAccessToken.current() != nil {
      self.authService.authWithFacebook()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true

    buttonView?.layer.cornerRadius = 5
    button?.layer.cornerRadius = 5

    trackScreen(screenName: String(describing: LoginViewController.self))
    button?.centerTextAndImage(spacing: 8.0)

    // user is logged in
    if FBSDKAccessToken.current() != nil {
      button?.isHidden = true
      buttonView?.isHidden = true
    } else {
      button?.isHidden = false
      buttonView?.isHidden = false
    }

    stopLoading()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, with: event)
  }

  func startLoading() {
    UIApplication.shared.beginIgnoringInteractionEvents()
    button?.isHidden = true
    indicator?.isHidden = false
    indicator?.startAnimating()
  }

  func stopLoading() {
    UIApplication.shared.endIgnoringInteractionEvents()
    indicator?.stopAnimating()
    indicator?.isHidden = true
  }

  func presentAlertForFirebaseError(errorCode: FIRAuthErrorCode) {
    var title = ""
    var message = ""
    switch errorCode {
    case .errorCodeEmailAlreadyInUse:
      title = "Email Taken"
      message = "An account with that email address already exists."
    case .errorCodeInvalidEmail:
      title = "Invalid Email"
      message = "Please enter a valid email address."
    case .errorCodeInvalidCredential:
      title = "Invalid Credentials"
      message = "The specified authentication credentials are invalid."
    case .errorCodeWrongPassword:
      title = "Incorrect Password"
      message = "The entered password does not match our records."
    case .errorCodeUserNotFound:
      title = "No Account Found"
      message = "You must login with Facebook if you created your account with Facebook."
    case .errorCodeNetworkError:
      title = "Network Error"
      message = "An error occurred while trying to login"
    default:
      title = "Error"
      message = "There was an error logging in. Please try again."
    }

    presentAlert(alertOptions: AlertOptions(message: message, title: title))
  }

  func loginWithFacebook() {
    let facebookLogin = FBSDKLoginManager()
    facebookLogin.logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: self) {
      facebookResult, facebookError -> Void in
      if facebookError != nil {
        self.onFacebookError()
      } else if facebookResult?.isCancelled == true {
        print("Facebook log in was cancelled.")
        // Do nothing.
      } else {
        self.authService.authWithFacebook()
      }
    }
  }

  func onFacebookError() {
    let title = "Authentication Error"
    let message = "An error occured while connecting to Facebook. Please try again."
    presentAlert(alertOptions: AlertOptions(message: message, title: title))
  }

}

// MARK: - FirebaseLoginDelegate
extension LoginViewController: FirebaseLoginDelegate {

  func onLoginError(errorCode: FIRAuthErrorCode) {
    stopLoading()
    presentAlertForFirebaseError(errorCode: errorCode)
  }

  func onLoginSuccess(user: User) {
    self.user = user

    startLoadingData() {
      self.stopLoading()
    }
  }

}
