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

//  func addPassengerToRide(user: User?, ride: Ride) {
//    if let id = user?.id {
//      if let rideId = ride.id {
//        // add to ride's current passengers
//        var requestedRef = ref.child("rides/\(rideId)/passengers/\(id)")
//        requestedRef.setValue(true)
//
//        // also remove user from ride's current pending requests
//        ref.child("rides/\(rideId)/pendingRequests/\(id)").removeValue()
//
//        // also remove from passenger's pending requested rides
//        ref.child("users/\(id)/pendingRequests/\(rideId)").removeValue()
//
//        // also add ride to passenger's rides
//        requestedRef = ref.child("users/\(id)/rides/\(rideId)")
//        requestedRef.setValue(true)
//
//        // decrement the seatsAvailable
//        requestedRef = ref.child("rides/\(rideId)/seatsAvailable")
//        requestedRef.observeSingleEvent(of: .value, with: { (snapshot) in
//          let seats = (snapshot.value as? NSNumber)!.intValue - 1
//          rideRef.setValue(seats)
//        }) { (error) in
//          print(error.localizedDescription)
//        }
//      }
//    }
//  }

  func addPassengerToRideRequests(user: User?, ride: Ride) {
    if let id = user?.id {
      if let rideId = ride.id {
        // add to ride's current pending requests
        var requestedRef = ref.child("rides/\(rideId)/pendingRequests/\(id)")
        requestedRef.setValue(true)

        // add to passenger's requested rides
        requestedRef = ref.child("users/\(id)/pendingRequests/\(rideId)")
        requestedRef.setValue(true)
      }
    }
  }

  func acceptPassengerIntoRide(passengerId: String, rideId: String) {
    // remove user from pendingRequests
    ref.child("rides/\(rideId)/pendingRequests/\(passengerId)").removeValue()

    // put user in the passengers of the ride
    var rideRef = ref.child("rides/\(rideId)/passengers/\(passengerId)")
    rideRef.setValue(true)

    let ridesRef = ref.child("rides/\(rideId)")
    let query = ridesRef.queryOrderedByKey()

    query.observe(.childAdded, with: { snapshot in
      let ride = Ride(fromSnapshot: snapshot)
      ride.passengers.append(passengerId)
    })

    // decrement the seatsAvailable
    rideRef = ref.child("rides/\(rideId)/seatsAvailable")
    rideRef.observeSingleEvent(of: .value, with: { (snapshot) in
      let seats = (snapshot.value as? NSNumber)!.intValue - 1
      rideRef.setValue(seats)
    }) { (error) in
      print(error.localizedDescription)
    }

    // remove from passenger's pending requests
    ref.child("users/\(passengerId)/pendingRequests/\(rideId)").removeValue()

    // add the ride to the passenger's rides
    let passRef = ref.child("users/\(passengerId)/rides/\(rideId)")
    passRef.setValue(true)
  }

  func doNotAcceptPassengerIntoRide(passengerId: String, rideId: String) {
    // remove user from pendingRequests
    ref.child("rides/\(rideId)/pendingRequests/\(passengerId)").removeValue()

    // remove from passenger's pending requests
    ref.child("users/\(passengerId)/pendingRequests/\(rideId)").removeValue()
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

  func removeRide(ride: Ride) {
    // remove from passengers rides
    for pass in ride.passengers {
        ref.child("users/\(pass)/rides/\(ride.id!)").removeValue()
    }

    // remove ride
    ref.child("rides/\(ride.id!)").removeValue()
    
    // remove from driver's rides
    ref.child("users/\(ride.driver!.id!)/rides/\(ride.id!)").removeValue()
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
