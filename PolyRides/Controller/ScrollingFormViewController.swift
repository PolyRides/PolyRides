//
//  ScrollingFormViewController.swift
//  PolyRides
//
//  Created by Myra Lukens on 1/19/17.
//  Copyright © 2017 Vanessa Forney. All rights reserved.
//

import UIKit

class ScrollingFormViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

  var activeFieldRect: CGRect?
  var keyboardRect: CGRect?
  var scrollView: UIScrollView!

  override func viewDidLoad() {

    self.automaticallyAdjustsScrollViewInsets = false

    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    view.addGestureRecognizer(tap)
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.registerForKeyboardNotifications()
    for view in self.view.subviews {
      if let v = view as? UITextView {
        let tv = v
        tv.delegate = self
      } else if let v = view as? UITextField {
        let tf = v
        tf.delegate = self
      }
    }
    scrollView = UIScrollView(frame: self.view.frame)
    scrollView.isScrollEnabled = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.addSubview(self.view)
    self.view = scrollView
  }

  override func viewDidLayoutSubviews() {
    scrollView.sizeToFit()
    scrollView.contentSize = scrollView.frame.size
    super.viewDidLayoutSubviews()
  }

  deinit {
    self.deregisterFromKeyboardNotifications()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func registerForKeyboardNotifications() {
    //Adding notifies on keyboard appearing
    NotificationCenter.default.addObserver(self,
      selector: #selector(ScrollingFormViewController.keyboardWasShown),
      name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self,
      selector: #selector(ScrollingFormViewController.keyboardWillBeHidden),
      name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }


  func deregisterFromKeyboardNotifications() {
    //Removing notifies on keyboard appearing
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  func keyboardWasShown(notification: NSNotification) {
    let info: NSDictionary = notification.userInfo! as NSDictionary
    keyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    adjustForKeyboard()
  }


  func keyboardWillBeHidden(notification: NSNotification) {
    keyboardRect = nil
    adjustForKeyboard()
  }

  func adjustForKeyboard() {
    if keyboardRect != nil && activeFieldRect != nil {
      let aRect: CGRect = scrollView.convert(activeFieldRect!, to: nil)
      if (keyboardRect!.contains(CGPoint(x: aRect.origin.x, y: aRect.maxY))) {
        scrollView.isScrollEnabled = true
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardRect!.size.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.scrollRectToVisible(activeFieldRect!, animated: true)
      }
    } else {
      let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
      scrollView.isScrollEnabled = false
    }
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    activeFieldRect = textView.frame
    adjustForKeyboard()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    activeFieldRect = nil
    adjustForKeyboard()
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeFieldRect = textField.frame
    adjustForKeyboard()
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    activeFieldRect = nil
    adjustForKeyboard()
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
  }

  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
}
