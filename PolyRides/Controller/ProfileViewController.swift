//
//  ProfileViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

  var user: User?

  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var descriptionTextView: UITextView?
  @IBOutlet weak var carDetailsLabel: UILabel?
  @IBOutlet weak var verifiedImage: UIImageView?

  override func viewDidLoad() {
    super.viewDidLoad()

    setupProfile()
  }

  func setupProfile() {
    if let imageView = imageView {
      imageView.clipsToBounds = true
      imageView.contentMode = UIViewContentMode.ScaleAspectFill
      imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }

    var name = ""
    if let firstName = user?.firstName {
      if let lastName = user?.lastName {
        name = "\(firstName) \(lastName)"
      }
    }
    nameLabel?.text = name

    let defaultImage = UIImage(named: "empty_profile")
    if let url = user?.imageURL {
      if let imageURL = NSURL(string: url) {
        if let placeholder = defaultImage {
          imageView?.setImageWithURL(imageURL, placeholderImage: placeholder)
        }
      } else {
        imageView?.image = defaultImage
      }
    } else {
      imageView?.image = defaultImage
    }

    if let description = user?.description {
      descriptionTextView?.text = description
      descriptionTextView?.hidden = false
    } else {
      descriptionTextView?.hidden = true
    }

    if user?.verifications.indexOf(Verification.CalPoly) != nil {

    }

    if let carDetails = user?.car?.getDescription() {
      carDetailsLabel?.text = carDetails
    } else {
      carDetailsLabel?.text = ""
    }
  }

}
