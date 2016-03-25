//
//  RideService.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

protocol FirebaseRidesDelegate: class {

  func onRideReceived(ride: Ride)
  func onNumRidesReceived(numRides: Int)

}

class RideService {

  let ref = FirebaseConnection.ref

  var delegate: FirebaseRidesDelegate?

  func getRidesForUser(user: User) {
    if let userId = user.id {
      let ridesRef = ref.childByAppendingPath("users/\(userId)/rides")
      ridesRef?.observeSingleEventOfType(.Value, withBlock: { snapshot in
        self.delegate?.onNumRidesReceived(snapshot.children.allObjects.count)

        if let children = snapshot.children.allObjects as? [FDataSnapshot] {
          for child in children {
            if let key = child.key {
              let rideRef = self.ref.childByAppendingPath("rides/\(key)")
              rideRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                let ride = Ride(fromSnapshot: snapshot)
                self.delegate?.onRideReceived(ride)
              })
            }
          }
        }
      })
    }
  }

  func getSavedRidesForUser(user: User) {
    if let userId = user.id {
      let ridesRef = ref.childByAppendingPath("users/\(userId)/saved")
      ridesRef?.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let children = snapshot.children.allObjects as? [FDataSnapshot] {
          for child in children {
            if let key = child.key {
              let rideRef = self.ref.childByAppendingPath("rides/\(key)")
              rideRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                let ride = Ride(fromSnapshot: snapshot)
                user.savedRides.append(ride)
              })
            }
          }
        }
      })
    }
  }

  func getAllRides() {
    let currentDateMillis = NSDate().timeIntervalSince1970
    let ridesRef = ref.childByAppendingPath("rides")
    let query = ridesRef?.queryOrderedByChild("date").queryStartingAtValue(currentDateMillis)
    query?.observeSingleEventOfType(.Value, withBlock: { snapshot in
      self.delegate?.onNumRidesReceived(snapshot.children.allObjects.count)

      if let children = snapshot.children.allObjects as? [FDataSnapshot] {
        for child in children {
          let ride = Ride(fromSnapshot: child)

          if let driverId = ride.driver?.id {
            let driverRef = self.ref.childByAppendingPath("users/\(driverId)")
            driverRef?.observeSingleEventOfType(.Value, withBlock: { snapshot in
              if let driver = ride.driver {
                driver.updateFromSnapshot(snapshot)
                self.delegate?.onRideReceived(ride)
              }
            })
          }
        }
      }
    })
  }

  func pushRideToFirebase(ride: Ride) {
    let rideRef = ref.childByAppendingPath("rides").childByAutoId()
    if let id = ride.driver?.id {
      let userRideRef = ref.childByAppendingPath("users/\(id)/rides/\(rideRef.key)")
      userRideRef.setValue(true)
      rideRef.setValue(ride.toAnyObject())
    }
  }

  func addToSaved(user: User?, ride: Ride) {
    if let id = user?.id {
      if let rideId = ride.id {
        let savedRef = ref.childByAppendingPath("users/\(id)/saved/\(rideId)")
        savedRef.setValue(true)
      }
    }
  }

  func removeFromSaved(user: User?, ride: Ride) {
    if let id = user?.id {
      if let rideId = ride.id {
        ref.childByAppendingPath("users/\(id)/saved/\(rideId)").removeValue()
      }
    }
  }

}
