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
  func onRideRemoved(ride: Ride)
}

extension FirebaseRidesDelegate {

  func onRideAdded(ride: Ride) {
    print("ride added:")
    print(ride.printString())
  }
  func onRideRemoved(ride: Ride) {
    print("ride removed:")
    print(ride.printString())
  }

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

  func monitorRidesForUser(user: User) {
    //monitor if they are accepted into a ride -- would need to be added to their myrides
    if let userId = user.id {
      let ridesRef = ref.child("users/\(userId)/rides")
      ridesRef.observe(.childAdded, with: { snapshot in
        self.delegate?.onNumRidesReceived(numRides: 1)

        let rideRef = self.ref.child("rides/\(snapshot.key)")
        rideRef.observeSingleEvent(of: .value, with: { snapshot in
          let ride = Ride(fromSnapshot: snapshot)
          self.delegate?.onRideReceived(ride: ride)
        })
      })

      ridesRef.observe(.childRemoved, with: { snapshot in
        self.delegate?.onNumRidesReceived(numRides: 1)

        let rideRef = self.ref.child("rides/\(snapshot.key)")
        rideRef.observeSingleEvent(of: .value, with: { snapshot in
          let ride = Ride(fromSnapshot: snapshot)
          self.delegate?.onRideRemoved(ride: ride)
        })
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

  func addPassengerToRideRequests(user: User?, ride: Ride) {
    if let id = user?.id {
      if let rideId = ride.id {
        // add to ride's current pending requests
        var requestedRef = ref.child("rides/\(rideId)/pendingRequests/\(id)")
        requestedRef.setValue(user?.getFullName())

        // add to passenger's requested rides
        requestedRef = ref.child("users/\(id)/pendingRequests/\(rideId)")
        requestedRef.setValue(true)
      }
    }
  }

  func acceptPassengerIntoRide(passengerId: String, passengerName: String, rideId: String) {
    // remove user from pendingRequests
    ref.child("rides/\(rideId)/pendingRequests/\(passengerId)").removeValue()

    // put user in the passengers of the ride
    var rideRef = ref.child("rides/\(rideId)/passengers/\(passengerId)")
    rideRef.setValue(passengerName)

    let ridesRef = ref.child("rides/\(rideId)")
    let query = ridesRef.queryOrderedByKey()

    query.observe(.childAdded, with: { snapshot in
      let ride = Ride(fromSnapshot: snapshot)
      ride.passengers.updateValue(passengerName, forKey: passengerId)
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

//  func monitorRides() {
//    let currentDateMillis = NSDate().timeIntervalSince1970
//    let ridesRef = ref.child(
//      "rides")
//    let query = ridesRef.queryOrdered(byChild: "date").queryStarting(atValue: currentDateMillis)
//
//    query.observe(.childAdded, with: { snapshot in
//      self.delegate?.onNumRidesReceived(numRides: 1)
//
//      let ride = Ride(fromSnapshot: snapshot)
//
//      if let driverId = ride.driver?.id {
//        let driverRef = self.ref.child("users/\(driverId)")
//        driverRef.observeSingleEvent(of: .value, with: { snapshot in
//          if let driver = ride.driver {
//            driver.updateFromSnapshot(snapshot: snapshot)
//            self.delegate?.onRideAdded(ride: ride)
//          }
//        })
//      }
//    })
//
//    query.observe(.childAdded, with: { snapshot in
//      self.delegate?.onNumRidesReceived(numRides: 1)
//
//      let ride = Ride(fromSnapshot: snapshot)
//
//      if let driverId = ride.driver?.id {
//        let driverRef = self.ref.child("users/\(driverId)")
//        driverRef.observeSingleEvent(of: .value, with: { snapshot in
//          if let driver = ride.driver {
//            driver.updateFromSnapshot(snapshot: snapshot)
//            self.delegate?.onRideRemoved(ride: ride)
//          }
//        })
//      }
//    })
//  }

  func pushRideToFirebase(ride: Ride) {
    let rideRef = ref.child("rides").childByAutoId()
    ride.id = rideRef.key
    if let id = ride.driver?.id {
      let userRideRef = ref.child("users/\(id)/rides/\(rideRef.key)")
      userRideRef.setValue(true)
      rideRef.setValue(ride.toAnyObject())
    }
  }

  func getUpdatedUserDataForRide(ride: Ride) {
    if let driverId = ride.driverId {
      let userRef = ref.child("users/\(driverId)")
      let query = userRef.queryOrderedByKey()

      query.observeSingleEvent(of: .value, with: { snapshot in
        let user = User()
        user.updateFromSnapshot(snapshot: snapshot)
        ride.driver = user
      })
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

  func removePassengerFromRide(ride: Ride, passenger: User) {
    // remove from passenger's rides
    ref.child("users/\(passenger.id!)/rides/\(ride.id!)").removeValue()

    // remove passenger from ride
    ref.child("rides/\(ride.id!)/passengers/\(passenger.id!)").removeValue()

    // increment seats available
    let rideRef = ref.child("rides/\(ride.id!)/seatsAvailable")
    rideRef.observeSingleEvent(of: .value, with: { (snapshot) in
      let seats = (snapshot.value as? NSNumber)!.intValue + 1
      rideRef.setValue(seats)
    }) { (error) in
      print(error.localizedDescription)
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
