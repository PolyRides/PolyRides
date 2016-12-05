//
//  GoogleAnalyticsHelper.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/11/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class GoogleAnalyticsHelper {

  class func trackScreen(name: String) {
    let tracker = GAI.sharedInstance().defaultTracker
    tracker?.set(kGAIScreenName, value: name)

    let builder: NSObject = GAIDictionaryBuilder.createScreenView().build()
    if let builder = builder as? [NSObject : AnyObject] {
      tracker?.send(builder)
    }
  }

}
