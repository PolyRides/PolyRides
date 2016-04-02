//
//  UIButtonExtensions.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/31/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

extension UIButton {
  func centerTextAndImage(spacing: CGFloat) {
    let insetAmount = spacing / 2
    imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
    titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
  }
}
