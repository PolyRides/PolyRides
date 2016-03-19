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

class LoginViewController: UIViewController {

  var user: User?
<<<<<<< HEAD
  var buttonTitle = ""
=======
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df

  @IBOutlet weak var emailTextField: UITextField?
  @IBOutlet weak var passwordTextField: UITextField?

  @IBOutlet weak var indicator: UIActivityIndicatorView?
  @IBOutlet weak var button: UIButton?

  override func viewDidLoad() {
    super.viewDidLoad()

    emailTextField?.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
    passwordTextField?.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
<<<<<<< HEAD
    FirebaseConnection.service.loginDelegate = self
=======
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = true
    textFieldDidChange()
<<<<<<< HEAD
=======
    addObservers()
  }

  override func viewWillDisappear(animated: Bool) {
    removeObservers()
    super.viewWillDisappear(animated)
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }

  func startLoading() {
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    button?.setTitle("", forState: UIControlState.Normal)
    indicator?.startAnimating()
  }

<<<<<<< HEAD
  func stopLoading() {
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
    indicator?.stopAnimating()
    button?.setTitle(buttonTitle, forState: UIControlState.Normal)
=======
  func stopLoading(title: String = "") {
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
    indicator?.stopAnimating()
    button?.setTitle(title, forState: UIControlState.Normal)
  }

  func removeObservers() {
    let defaultCenter = NSNotificationCenter.defaultCenter()
    var name = FirebaseConnection.LoginError
    defaultCenter.removeObserver(self, name: name, object: nil)

    name = FirebaseConnection.FBError
    defaultCenter.removeObserver(self, name: name, object: nil)

    name = FirebaseConnection.LoginSuccess
    defaultCenter.removeObserver(self, name: name, object: nil)
  }

  func addObservers() {
    let defaultCenter = NSNotificationCenter.defaultCenter()
    var name = FirebaseConnection.LoginError
    defaultCenter.addObserver(self, selector: Selector("onLoginError:"), name: name, object: nil)

    name = FirebaseConnection.FBError
    defaultCenter.addObserver(self, selector: Selector("onFacebookError"), name: name, object: nil)

    name = FirebaseConnection.LoginSuccess
    defaultCenter.addObserver(self, selector: Selector("onLoginSuccess:"), name: name, object: nil)
  }

  func onFacebookError() {
    let title = FirebaseConnection.FBErrorTitle
    let message = FirebaseConnection.FBErrorMessage
    presentAlert(AlertOptions(title: title, message: message))
  }

  func onLoginError(notification: NSNotification) {
    if let error = notification.object as? NSError {
      presentAlertForFirebaseError(error)
    }
  }

  func onLoginSuccess(notification: NSNotification) {
    stopLoading("")
    if let user = notification.object as? User {
      self.user = user
      FirebaseConnection.pushUserToFirebase(user)
      startMain()
    }
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
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
    facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) {
      facebookResult, facebookError -> Void in
      if facebookError != nil {
        self.onFacebookError()
      } else if facebookResult.isCancelled {
        print("Facebook log in was cancelled.")
        // Do nothing.
      } else {
<<<<<<< HEAD
        FirebaseConnection.service.authWithFacebook()
=======
        FirebaseConnection.authWithFacebook()
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
      }
    }
  }

  func loginWithEmail() {
    if let email = emailTextField?.text {
      if let password = passwordTextField?.text {
<<<<<<< HEAD
        FirebaseConnection.service.authUser(email, password: password)
=======
        FirebaseConnection.authUser(email, password: password)
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
      }
    }
  }

<<<<<<< HEAD
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

=======
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
  func startMain(action: UIAlertAction? = nil) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewControllerWithIdentifier("Main")
    if let tabBarVC = viewController as? TabBarController {
      tabBarVC.user = user
      if let delegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
        delegate.window?.rootViewController = tabBarVC
      }
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
<<<<<<< HEAD

extension LoginViewController: FirebaseLoginDelegate {

  func onLoginError(error: NSError) {
    presentAlertForFirebaseError(error)
  }

  func onLoginSuccess(user: User) {
    stopLoading()
    self.user = user
    FirebaseConnection.service.pushUserToFirebase(user)
    startMain()
  }

  func passwordResetSuccess(email: String) {
    stopLoading()
    let title = "Password Successfully Reset"
    let message = "Please check your email for your temporary password."
    presentAlert(AlertOptions(message: message, title: title, handler: onPasswordReset))
  }

  func temporaryPassword(user: User) {
    stopLoading()
    self.user = user
    if let temporaryPassword = passwordTextField?.text {
      self.performSegueWithIdentifier("toResetPassword", sender: temporaryPassword)
    }
  }


}
=======
>>>>>>> df43ab7300cf1dd95ce08c551ff6e524de6ce2df
