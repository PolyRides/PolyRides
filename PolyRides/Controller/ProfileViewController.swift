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

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }

    FirebaseConnection.service.userDelegate = self

    if let imageView = imageView {
      imageView.clipsToBounds = true
      imageView.contentMode = UIViewContentMode.ScaleAspectFill
      imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }
  }

}

extension ProfileViewController: FirebaseUserDelegate {

  func onUserUpdated() {
    var name = ""
    if let firstName = user?.firstName {
      if let lastName = user?.lastName {
        name = "\(firstName) \(lastName)"
      }
    }
    nameLabel?.text = name

    let defaultImage = UIImage(named: "empty_profile")
    if let imageURL = user?.imageURL {
      print(imageURL)
      if let url =  NSURL(string: imageURL) {
        if let placeholder = defaultImage {
          imageView?.setImageWithURL(url, placeholderImage: placeholder)
        }
      }
    } else {
      imageView?.image = defaultImage
    }
  }

}
