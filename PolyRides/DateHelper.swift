//
//  DateHelper.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/17/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class DateHelper {

  static func nearestHalfHour() -> Date {
    let calendar = Calendar.current
    let date = Date()
    let minuteComponent = calendar.dateComponents([.minute], from: date)
    var components = DateComponents()
    components.minute = 30 - minuteComponent.minute! % 30

    if let date = calendar.date(byAdding: components, to: date) {
      return date
    }
    return Date()
  }

}
