//
//  UITextLabelExtensions.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

extension UITextField {

  func isValidEmail() -> Bool {
    if let text = self.text {
      let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
      return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(text)
    }
    return false
  }

  func isValidPassword() -> Bool {
    if let text = self.text {
      if text != "" && text.characters.count >= 5 {
        return true
      }
    }
    return false
  }

  func addTargetForEditing(view: UIViewController, selector: Selector) {
    self.addTarget(view, action: selector, forControlEvents: UIControlEvents.EditingChanged)
  }

}
