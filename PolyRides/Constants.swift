//
//  Constants.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/4/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps

struct Color {

  static let White = UIColor(red: 236.0/255, green: 240.0/255, blue: 241.0/255, alpha: 1.0)
  static let DarkNavy = UIColor(red: 45.0/255, green: 62.0/255, blue: 79.0/255, alpha: 1.0)
  static let Navy = UIColor(red: 53.0/255, green: 73.0/255, blue: 93.0/255, alpha: 1.0)
  static let Gray = UIColor(red: 143.0/255, green: 142.0/255, blue: 148.0/255, alpha: 1.0)

}

struct Font {

  static let NavigationBarTitle = UIFont(name: "OpenSans-Semibold", size: 17)!
  static let NavigationBarButton = UIFont(name: "OpenSans", size: 17)!
  static let TabBar = UIFont(name: "OpenSans", size: 10)!
  static let SegmentedControl = UIFont(name: "OpenSans", size: 13)!
  static let SearchBar = UIFont(name: "OpenSans", size: 13.5)!
  static let TableHeader = UIFont(name: "OpenSans", size: 13.5)!
  static let TableRow = UIFont(name: "OpenSans", size: 16.5)!
  static let TableRowSubline = UIFont(name: "OpenSans", size: 12)!

}

struct Empty {

  static let SearchTitle = "No rides were found."
  static let SearchMessage = "We don't have any rides departing within 24 hours of the specified date, please check back later."
  static let BeginSearchTitle = "Search for a ride."
  static let BeginSearchMessage = "Enter from and to locations and a departure date,\nand rides within 24 hours will show up."

}

struct Bounds {

  static let TopLeft = CLLocationCoordinate2DMake(41.975926, -124.509506)
  static let BottomRight = CLLocationCoordinate2DMake(32.974171, -113.799198)
  static let California = GMSCoordinateBounds(coordinate: Bounds.TopLeft, coordinate: Bounds.BottomRight)

}

struct Filter {

  static func US() -> GMSAutocompleteFilter {
    let filter = GMSAutocompleteFilter()
    filter.country = "US"
    return filter
  }

}