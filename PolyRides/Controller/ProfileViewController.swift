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
  var mutualFriends: [User]?

  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var descriptionTextView: UITextView?
  @IBOutlet weak var carDetailsLabel: UILabel?
  @IBOutlet weak var phoneLabel: UILabel?
  @IBOutlet weak var verifiedImage: UIImageView?
  @IBOutlet weak var mutualFriendsButton: UIButton?

  override func viewDidLoad() {
    super.viewDidLoad()

    setupProfile()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toMutualFriends" {
      if let vc = segue.destination as? MutualFriendsTableViewController {
        vc.mutualFriends = mutualFriends
        vc.otherUser = user
      }
    }
  }

  func setupProfile() {
    if let imageView = imageView {
      imageView.clipsToBounds = true
      imageView.contentMode = UIViewContentMode.scaleAspectFill
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
          imageView?.setImageWith(imageURL as URL, placeholderImage: placeholder)
        }
      } else {
        imageView?.image = defaultImage
      }
    } else {
      imageView?.image = defaultImage
    }

    if let description = user?.description {
      descriptionTextView?.text = description
      descriptionTextView?.isHidden = false
    } else {
      descriptionTextView?.isHidden = true
    }

    if user?.verifications.index(of: Verification.CalPoly) != nil {
      verifiedImage?.isHidden = false
    } else {
      verifiedImage?.isHidden = true
    }

    if let carDetails = user?.car?.getDescription() {
      carDetailsLabel?.text = carDetails
    } else {
      carDetailsLabel?.text = ""
    }

    if let phone = user?.phoneNumber {
      phoneLabel?.text = phone
    } else {
      phoneLabel?.text = ""
    }

    mutualFriendsButton?.setTitle("\(mutualFriends?.count ?? 0) mutual friends", for: .normal)
    mutualFriendsButton?.centerTextAndImage(spacing: 4)
  }

}
