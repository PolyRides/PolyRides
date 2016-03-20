//
//  TabBarViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/15/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class TabBarController: UITabBarController {

  var user: User?

  override func viewDidLoad() {
    super.viewDidLoad()

    viewControllers?.forEach {
      if let vc = $0 as? UINavigationController {
        vc.topViewController?.view
      }
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBarHidden = false
  }

}
