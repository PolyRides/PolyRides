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
  let configurationHandler: ((_ textField: UITextField?) -> Void)?

  init(message: String = DefaultMessage, title: String = DefaultTitle, acceptText: String = "OK",
       handler: ((UIAlertAction) -> Void)? = nil, showCancel: Bool = false,
       configurationHandler: ((_ textField: UITextField?) -> Void)? = nil) {
    self.message = message
    self.title = title
    self.acceptText = acceptText
    self.handler = handler
    self.showCancel = showCancel
    self.configurationHandler = configurationHandler
  }
}

extension UIViewController {

  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, with: event)
  }

  func setupAppearance() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.barTintColor = Color.Navy

    tabBarController?.tabBar.isTranslucent = false
    tabBarController?.tabBar.tintColor = Color.Navy

    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
  }

  func presentAlert(alertOptions: AlertOptions = AlertOptions()) {
    let title = alertOptions.title
    let message = alertOptions.message
    let acceptText = alertOptions.acceptText
    let handler = alertOptions.handler
    let configurationHandler = alertOptions.configurationHandler
    let style = UIAlertControllerStyle.alert

    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    alert.addAction(UIAlertAction(title: acceptText, style: .default, handler: handler))
    if configurationHandler != nil {
      alert.addTextField(configurationHandler: configurationHandler)
    }
    if alertOptions.showCancel {
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    self.present(alert, animated: true, completion: nil)
  }

  func trackScreen(screenName: String) {
    GoogleAnalyticsHelper.trackScreen(name: screenName)
  }

}
