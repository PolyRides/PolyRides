//
//  UIViewControllerExtensions.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

struct AlertOptions {

  static let DefaultMessage = "Error"
  static let DefaultTitle = "An error occurred. Please try again."

  let title: String
  let message: String
  let acceptText: String
  let handler: ((UIAlertAction) -> Void)?
  let showCancel: Bool
  let configurationHandler: ((textField: UITextField!) -> Void)?

  init(message: String = DefaultMessage, title: String = DefaultTitle, acceptText: String = "OK",
       handler: ((UIAlertAction) -> Void)? = nil, showCancel: Bool = false,
       configurationHandler: ((textField: UITextField!) -> Void)? = nil) {
    self.message = message
    self.title = title
    self.acceptText = acceptText
    self.handler = handler
    self.showCancel = showCancel
    self.configurationHandler = configurationHandler
  }
}

extension UIViewController {

  func setupAppearance() {
    navigationController?.navigationBar.translucent = false
   // navigationController?.navigationBar.barStyle = .Black
   // navigationController?.navigationBar.barTintColor = Color.Blue

    tabBarController?.tabBar.translucent = false
    tabBarController?.tabBar.tintColor = Color.Blue
  }

  func presentAlert(alertOptions: AlertOptions = AlertOptions()) {
    let title = alertOptions.title
    let message = alertOptions.message
    let acceptText = alertOptions.acceptText
    let handler = alertOptions.handler
    let configurationHandler = alertOptions.configurationHandler
    let style = UIAlertControllerStyle.Alert

    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    alert.addAction(UIAlertAction(title: acceptText, style: .Default, handler: handler))
    if configurationHandler != nil {
      alert.addTextFieldWithConfigurationHandler(configurationHandler)
    }
    if alertOptions.showCancel {
      alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    }
    self.presentViewController(alert, animated: true, completion: nil)
  }

  func trackScreen(screenName: String) {
    GoogleAnalyticsHelper.trackScreen(screenName)
  }

  override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }

}
