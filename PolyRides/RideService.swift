//
//  RideService.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/22/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FirebaseDatabase

protocol FirebaseRidesDelegate {

  func onRideReceived(ride: Ride)
  func onNumRidesReceived(numRides: Int)

}

extension FirebaseRidesDelegate {

  func onRideAdded(ride: Ride) {}
  func onRideRemoved(ride: Ride) {}

}

class RideService {

  let ref = FIRDatabase.database().reference()

  var delegate: FirebaseRidesDelegate?

  func getRidesForUser(user: User) {
    if let userId = user.id {
      let ridesRef = ref.child("users/\(userId)/rides")
      ridesRef.observeSingleEvent(of: .value, with: { snapshot in
        self.delegate?.onNumRidesReceived(numRides: snapshot.children.allObjects.count)

        if let children = snapshot.children.allObjects as? [FIRDataSnapshot] {
          for child in children {
            let rideRef = self.ref.child("rides/\(child.key)")
            rideRef.observeSingleEvent(of: .value, with: { snapshot in
              let ride = Ride(fromSnapshot: snapshot)
              self.delegate?.onRideReceived(ride: ride)
            })
          }
        }
      })
    }
  }

  func getSavedRidesForUser(user: User) {
    if let userId = user.id {
      let ridesRef = ref.child(
        "users/\(userId)/saved")
      ridesRef.observeSingleEvent(of: .value, with: { snapshot in
        if let children = snapshot.children.allObjects as? [FIRDataSnapshot] {
          for child in children {
            let rideRef = self.ref.child("rides/\(child.key)")
            rideRef.observeSingleEvent(of: .value, with: { snapshot in
              let ride = Ride(fromSnapshot: snapshot)

              if let driverId = ride.driver?.id {
                let driverRef = self.ref.child("users/\(driverId)")
                driverRef.observeSingleEvent(of: .value, with: { snapshot in
                  if let driver = ride.driver {
                    driver.updateFromSnapshot(snapshot: snapshot)
                    user.savedRides.append(ride)
                  }
                })
              }
            })
          }
        }
      })
    }
  }

  func getAllRides() {
    let currentDateMillis = NSDate().timeIntervalSince1970
    let ridesRef = ref.child(
      "rides")
    let query = ridesRef.queryOrdered(byChild: "date").queryStarting(atValue: currentDateMillis)

    query.observeSingleEvent(of: .value, with: { snapshot in
      self.delegate?.onNumRidesReceived(numRides: snapshot.children.allObjects.count)

      if let children = snapshot.children.allObjects as? [FIRDataSnapshot] {
        for child in children {
          let ride = Ride(fromSnapshot: child)

          if let driverId = ride.driver?.id {
            let driverRef = self.ref.child("users/\(driverId)")
            driverRef.observeSingleEvent(of: .value, with: { snapshot in
              if let driver = ride.driver {
                driver.updateFromSnapshot(snapshot: snapshot)
                self.delegate?.onRideReceived(ride: ride)
              }
            })
          }
        }
      }
    })
  }

  func monitorRides() {
    let currentDateMillis = NSDate().timeIntervalSince1970
    let ridesRef = ref.child("rides")
    let query = ridesRef.queryOrdered(byChild: "date").queryStarting(atValue: currentDateMillis)

    query.observe(.childAdded, with: { snapshot in
      let ride = Ride(fromSnapshot: snapshot)

      if let driverId = ride.driver?.id {
        let driverRef = self.ref.child("users/\(driverId)")
        driverRef.observeSingleEvent(of: .value, with: { snapshot in
          if let driver = ride.driver {
            driver.updateFromSnapshot(snapshot: snapshot)
            self.delegate?.onRideAdded(ride: ride)
          }
        })
      }
    })

    query.observe(.childRemoved, with: { snapshot in
      self.delegate?.onRideRemoved(ride: Ride(fromSnapshot: snapshot))
    })
  }

  func pushRideToFirebase(ride: Ride) {
    let rideRef = ref.child("rides").childByAutoId()
    if let id = ride.driver?.id {
      let userRideRef = ref.child("users/\(id)/rides/\(rideRef.key)")
      userRideRef.setValue(true)
      rideRef.setValue(ride.toAnyObject())
    }
  }

  func addToSaved(user: User?, ride: Ride) {
    if let id = user?.id {
      if let rideId = ride.id {
        let savedRef = ref.child("users/\(id)/saved/\(rideId)")
        savedRef.setValue(true)
      }
    }
  }

  func removeFromSaved(user: User?, ride: Ride) {
    if let id = user?.id {
      if let rideId = ride.id {
        ref.child("users/\(id)/saved/\(rideId)").removeValue()
      }
    }
  }

}
