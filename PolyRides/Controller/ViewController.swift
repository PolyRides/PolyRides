//
//  ViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/11/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class ViewController: GAITrackedViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GoogleAnalyticsHelper.trackScreen(String(ViewController))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
