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
  static let Navy = UIColor(red: 9.0/255, green: 41.0/255, blue: 48.0/255, alpha: 1.0)


  static let Blue = UIColor(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1.0)
  static let LightGray = UIColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1.0)
  static let Gray = UIColor(red: 130.0/255, green: 137.0/255, blue: 141.0/255, alpha: 1.0)
  static let DarkGray = UIColor(red: 86.0/255, green: 90.0/255, blue: 92.0/255, alpha: 1.0)


}

struct Attributes {

  static let NavigationBar = [NSFontAttributeName: Font.NavigationBarTitle,
                              NSForegroundColorAttributeName: Color.DarkGray]
  static let SegmentedControl = [NSFontAttributeName: Font.SegmentedControl]

}

struct Font {

  static let NavigationBarTitle = UIFont(name: "OpenSans-Semibold", size: 17)!
  static let NavigationBarButton = UIFont(name: "OpenSans", size: 17)!
  static let TabBar = UIFont(name: "OpenSans", size: 10)!
  static let SegmentedControl = UIFont(name: "OpenSans", size: 13)!
  static let SearchBar = UIFont(name: "OpenSans", size: 13.5)!
  static let TableHeader = UIFont(name: "OpenSans", size: 13.5)!
  static let TableRow = UIFont(name: "OpenSans", size: 16.5)!
  static let TableRowBold = UIFont(name: "OpenSans-Semibold", size: 16.5)!
  static let EmptyTableHeader = UIFont(name: "OpenSans-Semibold", size: 16.5)!
  static let TableRowSubline = UIFont(name: "OpenSans", size: 12)!
  static let TextFieldPlaceholder = UIFont(name: "OpenSans-Semibold", size: 13.5)!

}

struct Empty {

  static let SearchTitle = "No rides were found."
  static let SearchMessage = "We don't have any rides departing within 24 hours of the specified date, please check back later."
  static let BeginSearchTitle = "Search for a ride."
  static let BeginSearchMessage = "Enter from and to locations and a departure date,\nand rides within 24 hours will show up."
  static let RegionTitle = "No rides were found"

  static let CurrentRidesTitle = "You haven't posted any rides, yet."
  static let CurrentRidesMessage = "Offer a ride by tapping the plus symbol\nin the top right."
  static let PastRidesTitle = "You haven't completed any rides, yet."
  static let PastRidesMessage = "When you offer and complete a ride,\nthat ride will appear here."
  static let SavedRidesTitle = "You haven't saved any rides, yet."
  static let SavedRidesMessage = "When viewing a ride in the search tab, you may save a ride by tapping the star in the top right."

  static func FromRegion(region: Region) -> String {
    if region == .Other {
      return "There are no other rides posted,\ntry checking back in a little while."
    }
    return "There are no rides leaving from \(region.referenceName()),\ntry checking back in a little while."
  }

  static func ToRegion(region: Region) -> String {
    if region == .Other {
      return "There are no other rides posted,\ntry checking back in a little while."
    }
    return "There are no rides going to \(region.referenceName()),\ntry checking back in a little while."
  }

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

struct Error {

  static let CurrentLocationTitle = "Error Finding Current Location"
  static let CurrentLocationMessage = "Please ensure location services are enabled and try again."

}