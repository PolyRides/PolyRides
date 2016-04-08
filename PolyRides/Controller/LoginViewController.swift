//
//  LoginViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

//
//  LoginViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase
import FBSDKLoginKit

class LoginViewController: LoadingViewController {

  let authService = AuthService()

  @IBOutlet weak var emailTextField: UITextField?
  @IBOutlet weak var passwordTextField: UITextField?

  @IBOutlet weak var indicator: UIActivityIndicatorView?
  @IBOutlet weak var button: UIButton?
  @IBOutlet weak var buttonView: UIView?

  override func viewDidLoad() {
    super.viewDidLoad()

    // emailTextField?.addTargetForEditing(self, selector: #selector(LoginViewController.textFieldDidChange))
    // passwordTextField?.addTargetForEditing(self, selector: #selector(LoginViewController.textFieldDidChange))
    authService.loginDelegate = self

    buttonView?.layer.cornerRadius = 5
    button?.layer.cornerRadius = 5
    //button?.layer.borderWidth = 1
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBarHidden = true
    textFieldDidChange()
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }

  func startLoading() {
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    button?.hidden = true
    indicator?.startAnimating()
  }

  func stopLoading() {
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
    indicator?.stopAnimating()
    button?.hidden = false
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
        message = "The entered password does not match our records."
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

  func loginWithFacebook() {
    let facebookLogin = FBSDKLoginManager()
    facebookLogin.logInWithReadPermissions(["email", "public_profile", "user_friends"], fromViewController: self) {
      facebookResult, facebookError -> Void in
      if facebookError != nil {
        self.onFacebookError()
      } else if facebookResult.isCancelled {
        print("Facebook log in was cancelled.")
        // Do nothing.
      } else {
        self.authService.authWithFacebook()
      }
    }
  }

  func loginWithEmail() {
    if let email = emailTextField?.text {
      if let password = passwordTextField?.text {
        authService.authUser(email, password: password)
      }
    }
  }

  func onFacebookError() {
    let title = "Authentication Error"
    let message = "An error occured while connecting to Facebook. Please try again."
    presentAlert(AlertOptions(title: title, message: message))
  }

  func onPasswordReset(alert: UIAlertAction) {
    if let navigationController = navigationController {
      if let vc = navigationController.viewControllers.first as? MainLoginViewController {
        if let email = emailTextField?.text {
          vc.emailTextField?.text = email
        }
      }
      navigationController.popViewControllerAnimated(true)
    }
  }

  func textFieldDidChange() {
    let invalidEmail = emailTextField?.isValidEmail() == false
    let invalidPassword = passwordTextField?.isValidPassword() == false
    if !invalidEmail && !invalidPassword {
      button?.enabled = true
    } else {
      button?.enabled = false
    }
  }

}

// MARK: - FirebaseLoginDelegate
extension LoginViewController: FirebaseLoginDelegate {

  func onLoginError(error: NSError) {
    stopLoading()
    presentAlertForFirebaseError(error)
  }

  func onLoginSuccess(user: User) {
    self.user = user
    startLoadingData() {
      self.stopLoading()
    }
  }

  func onHasTemporaryPassword(user: User) {
    stopLoading()
    self.user = user
    self.performSegueWithIdentifier("toResetPassword", sender: nil)
  }

}
