//
//  Region.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

enum Region: Int {
  case SFBay, LosAngeles, SanDiego, Sacramento, SanJoaquin, Other

  static let allRegions = [SFBay, LosAngeles, SanDiego, Sacramento, SanJoaquin, Other]
  static let regionNames = [
    SFBay: "SF Bay",
    LosAngeles: "Los Angeles",
    SanDiego: "San Diego",
    Sacramento: "Sacramento",
    SanJoaquin: "San Joaquin",
    Other: "Other"]

  static let regionImages = [
    SFBay: "san_francisco",
    LosAngeles: "los_angeles",
    SanDiego: "san_diego",
    Sacramento: "sacramento",
    SanJoaquin: "san_joaquin",
    Other: "other"
  ]

  func name() -> String {
    return Region.regionNames[self]!
  }

  func image() -> UIImage {
    return UIImage(named: Region.regionImages[self]!)!
  }

}
