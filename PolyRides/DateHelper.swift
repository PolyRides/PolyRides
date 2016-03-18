//
//  DateHelper.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/17/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class DateHelper {

  static func nearestHalfHour() -> NSDate {
    let calendar = NSCalendar.currentCalendar()
    let date = NSDate()
    let minuteComponent = calendar.components(NSCalendarUnit.Minute, fromDate: date)
    let components = NSDateComponents()
    components.minute = 30 - minuteComponent.minute % 30

    if let date = calendar.dateByAddingComponents(components, toDate: date, options: .MatchFirst) {
      return date
    }
    return NSDate()
  }

}
