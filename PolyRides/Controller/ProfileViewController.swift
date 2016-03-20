//
//  ProfileViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

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

    setDisplay()
  }

  func setDisplay() {
    var name = ""
    if let firstName = user?.firstName {
      if let lastName = user?.lastName {
        name = "\(firstName) \(lastName)"
      }
    }
    nameLabel?.text = name
   // imageView?.image.set
  }

}

extension ProfileViewController: FirebaseUserDelegate {

  func onUserUpdated() {
    setDisplay()
  }

}
