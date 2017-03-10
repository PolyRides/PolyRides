//
//  DriverProfileViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/3/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//
import UIKit
import MessageUI

class DriverProfileViewController: ProfileViewController, MFMessageComposeViewControllerDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func onPhoneButtonTapped(_ sender: Any) {
    if !MFMessageComposeViewController.canSendText() {
      print("SMS services are not available")
    } else {
      let composeVC = MFMessageComposeViewController()
      composeVC.messageComposeDelegate = self

      // Configure the fields of the interface.
      composeVC.recipients = [(user?.phoneNumber)!]
      if let ride = ride {
        composeVC.body = "Hi, I am interested in your ride from \(ride.getFormattedLocation()) on \(ride.getFormattedDate())"
      } else {
        composeVC.body = "Hi, I am interested in your ride"
      }

      // Present the view controller modally.
      self.present(composeVC, animated: true, completion: nil)
    }

  }

  func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                    didFinishWith result: MessageComposeResult) {
    controller.dismiss(animated: true, completion: nil)
  }

}
