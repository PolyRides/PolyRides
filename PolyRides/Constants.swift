//
//  Constants.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/4/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps
import GooglePlaces

struct Color {
  static let LightGray = UIColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1.0)

  static let Green = UIColor(red: 41.0/255, green: 85.0/255, blue: 26.0/255, alpha: 1.0)
  //static let White = UIColor(red: 236.0/255, green: 240.0/255, blue: 241.0/255, alpha: 1.0)
  //static let DarkWhite = UIColor(red: 189.0/255, green: 195.0/255, blue: 199.0/255, alpha: 1.0)
  static let Gray = UIColor(red: 86.0/255, green: 90.0/255, blue: 92.0/255, alpha: 1.0)
  static let Black = UIColor(red: 43.0/255, green: 43.0/255, blue: 43.0/255, alpha: 1.0)

}

struct Attributes {

  static let NavigationBar = [NSFontAttributeName: Font.NavigationBarTitle,
                              NSForegroundColorAttributeName: UIColor.white]
  static let SegmentedControl = [NSFontAttributeName: Font.SegmentedControl]
  static let TabBar = [NSFontAttributeName: Font.TabBar]

}

struct Font {

  static let NavigationBarTitle = UIFont(name: "SFUIText-Semibold", size: 17)!
  static let NavigationBarButton = UIFont(name: "SFUIText-Regular", size: 17)!
  static let TabBar = UIFont(name: "SFUIText-Regular", size: 10)!
  static let SegmentedControl = UIFont(name: "SFUIText-Regular", size: 13)!
  static let SearchBar = UIFont(name: "SFUIText-Regular", size: 13.5)!
  static let TableHeader = UIFont(name: "SFUIText-Regular", size: 13.5)!
  static let TableRow = UIFont(name: "SFUIText-Regular", size: 16.5)!
  static let TableRowBold = UIFont(name: "SFUIText-Semibold", size: 16.5)!
  static let EmptyTableHeader = UIFont(name: "SFUIText-Semibold", size: 16.5)!
  static let TableRowSubline = UIFont(name: "SFUIText-Regular", size: 12)!
  static let TextFieldPlaceholder = UIFont(name: "SFUIText-Semibold", size: 13.5)!

}

struct Empty {

  static let SearchTitle = "No rides were found."
  static let SearchMessage = "We don't have any rides departing within 24 hours of the specified date, please check back later."
  static let BeginSearchTitle = "Search for a ride."
  static let BeginSearchMessage = "Enter from and to locations and a departure date,\nand rides within 24 hours will show up."
  static let RegionTitle = "No rides were found."

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
