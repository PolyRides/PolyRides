//
//  RideSubmittedViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney and Myra Lukens on 3/4/15.
//  Copyright (c) 2015 Vanessa Forney and Myra Lukens. All rights reserved.
//

import Foundation
import UIKit

class RideSubmittedViewController: UIViewController {
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        
        let image = UIImage(named: "logo_small")
        self.navigationItem.titleView = UIImageView(image: image)
        
        _ = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: Selector("update"), userInfo: nil, repeats: false);
    }

    func update() {
        self.performSegue(withIdentifier: "unwindToAddRideViewControllerWithSegue", sender: self)
    }



}
