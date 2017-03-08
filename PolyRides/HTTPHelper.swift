//
//  HTTPHelper.swift
//  PolyRides
//
//  Created by Myra Lukens on 2/7/17.
//  Copyright © 2017 Vanessa Forney. All rights reserved.
//

import Foundation

class HTTPHelper {
  static func sendHTTPPost(jsonDict: [String : Any]) {
    let url = URL(string: "https://fcm.googleapis.com/fcm/send")
    let FBserverKey = "AAAAK596FGE:APA91bEjb9nD6-vPlfaGJ0uvumpajGEKnwOJHAIny5J3TGCYN8hNj62Co0b_4M0QTTvXxpp1TWgv0kgY02Nk2i5gNxQ0YdtAo7PiLxCQ0wH1BJLmEc61Z_elzR-iiaw8jOkE4SDLaLqK2SeopnegihLOEzHfKAj_Ig"

    do {
      let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
      var request = URLRequest(url: url!)
      request.httpMethod = "post"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("key=\(FBserverKey)", forHTTPHeaderField: "Authorization")
      request.httpBody = jsonData

      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
          print("error:", error)
          return
        }

        do {
          guard let data = data else { return }
          guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
          print("json:", json)
        } catch {
          print("error:", error)
        }
      }

      task.resume()
    } catch {
      print("errorssss")
    }
  }

  static func notifyPassengerOfRemovedRide(ride: Ride, user: User, iid: String) {
    let jsonDict = ["data": ["deletingRide": "true", "user":"\(user.getFullName())", "toPlaceCity": "\(ride.toLocation!.city!))", "fromPlaceCity": "\(ride.fromLocation!.city!)", "userId": "\(user.id!)", "rideId": "\(ride.id!)", "userInstanceId": "\(user.instanceID!)"], "to": "\(iid)"] as [String : Any]
    HTTPHelper.sendHTTPPost(jsonDict: jsonDict)
  }

}
