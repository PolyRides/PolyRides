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

  static let FBErrorMessage = "An error occured while connecting to Facebook. Please try again."
  static let FBErrorTitle = "Authentication Error"

  static let ChangePasswordSuccess = "ChangePasswordSuccess"
  static let ResetPasswordSuccess = "ResetPasswordSuccess"
  static let CreateAccountSuccess = "CreateAccountSuccess"
  static let LoginError = "LoginError"

  var user: User?

  @IBOutlet weak var emailTextField: UITextField?
  @IBOutlet weak var passwordTextField: UITextField?
  @IBOutlet weak var firstNameTextField: UITextField?
  @IBOutlet weak var lastNameTextField: UITextField?

  @IBOutlet weak var indicator: UIActivityIndicatorView?
  @IBOutlet weak var button: UIButton?

  func startLoading() {
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    button?.setTitle("", forState: UIControlState.Normal)
    indicator?.startAnimating()
  }

  func stopLoading(title: String) {
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
    indicator?.stopAnimating()
    button?.setTitle(title, forState: UIControlState.Normal)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    emailTextField?.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
    passwordTextField?.addTargetForEditing(self, selector: Selector("textFieldDidChange"))
    
    let defaultCenter = NSNotificationCenter.defaultCenter()
    let selector = Selector("onLoginError:")
    let name = LoginViewController.LoginError
    defaultCenter.addObserver(self, selector: selector, name: name, object: nil)

  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = true
    button?.enabled = false
  }

  func onFacebookError() {
    let title = LoginViewController.FBErrorTitle
    let message = LoginViewController.FBErrorMessage
    presentAlert(AlertOptions(title: title, message: message))
  }

  func onFacebookSuccess(authData: FAuthData) {
    let user = User(withAuthData: authData)
    user.pushToFirebase()
    startMain()
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

  func loginWithEmail(email: String, password: String) {
    FirebaseConnection.ref.authUser(email, password: password) { error, authData in
      self.stopLoading("Login")
      if error == nil {
        if let temporaryPassword = authData.providerData["isTemporaryPassword"] as? Bool {
          self.user = User(withAuthData: authData)
          if temporaryPassword {
            self.performSegueWithIdentifier("toResetPassword", sender: self)
          } else {
            self.startMain()
          }
        }
      } else {
        self.presentAlertForFirebaseError(error)
      }
    }
  }

  func toMainLogin(action: UIAlertAction) {
    if let navigationController = navigationController {
      if let vc = navigationController.topViewController as? MainLoginViewController {
        if let email = emailTextField?.text {
          if let password = passwordTextField?.text {
            vc.emailTextField?.text = email
            vc.passwordTextField?.text = password
            navigationController.popToRootViewControllerAnimated(true)
          }
        }
      }
    }
  }

  func startMain() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewControllerWithIdentifier("search")
    if let searchViewcontroller = viewController as? SearchTableViewController {
      searchViewcontroller.user = user
      if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
        appDelegate.window?.rootViewController = searchViewcontroller
      }
    }
  }

  func textFieldDidChange() {
    let empty = firstNameTextField?.text == "" || lastNameTextField?.text == ""
    let invalidEmail = emailTextField?.isValidEmail() == false
    let invalidPassword = passwordTextField?.isValidPassword() == false
    if !invalidEmail && !invalidPassword && !empty {
      button?.enabled = true
    } else {
      button?.enabled = false
    }
  }

}
