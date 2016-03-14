//
//  UIViewControllerExtensions.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/13/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

struct AlertOptions {

  let title: String
  let message: String

  init(message: String = "Error", title: String = "Please try again.") {
    self.message = message
    self.title = title
  }

}

extension UIViewController {

  func presentAlert(alertOptions: AlertOptions = AlertOptions()) {
    let alert = UIAlertController(title: alertOptions.title, message: alertOptions.message,
      preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }

  func trackScreen(screenName: String) {
    GoogleAnalyticsHelper.trackScreen(screenName)
  }

}
