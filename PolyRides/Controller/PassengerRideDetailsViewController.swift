//
//  PassengerRideDetailsViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import FBSDKCoreKit

class DriverTableViewCell: UITableViewCell {

  @IBOutlet weak var driverImageView: UIImageView?
  @IBOutlet weak var name: UILabel?

}

class PassengerRideDetailsViewController: RideDetailsViewController {

  let rideService = RideService()

  // TEMPORARY, FOR TESTING PURPOSES
  // IN THE FUTURE, INSTEAD USE THE INSTANCE ID OF THE CREATOR (DRIVER) OF THE RIDE
  let userInstanceID = "e5kRgW9kicE:APA91bFCb56SJBTgCFW2zr3FOJJ6ya6sfVKWjlxJs2c5vuuV43FGZmL3LrUIWTWw3_kjrlsI-hkf-kP1KEmkjS_JqK8VKejGoRHprFoWAQBMPNxZ2taHGFpLChUYjGh-0OQyceQDF5Pc"

  var mutualFriends = [User]()

  @IBOutlet weak var tableView: UITableView?
  @IBOutlet weak var saveButton: UIBarButtonItem?
  @IBOutlet weak var requestOrLeaveButton: UIButton?

  @IBAction func saveRideAction(sender: AnyObject) {
    if let ride = ride {
      let index = user?.savedRides.index(where: { $0.id == ride.id })
      if let index = index {
        let title = "Are you sure you want to remove this ride from saved?"
        presentAlert(alertOptions: AlertOptions(message: "", title: title, handler: { action in
          self.user?.savedRides.remove(at: index)
          self.rideService.removeFromSaved(user: self.user, ride: ride)
          self.setSavedIcon()
        }, showCancel: true))
      } else {
        user?.savedRides.append(ride)
        rideService.addToSaved(user: self.user, ride: ride)
        setSavedIcon()
      }
    } else {
      let title = "Saving Error"
      let message = "There was an error adding to your saved rides. Please try again."
      presentAlert(alertOptions: AlertOptions(message: message, title: title))
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.dataSource = self

    requestOrLeaveButton?.isHidden = true
    makeMutualFriendsRequest()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    setSavedIcon()
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  func setSavedIcon() {
    var image = UIImage(named: "star")
    if let ride = ride {
      if user?.savedRides.index(where: { $0.id == ride.id }) != nil {
        image = UIImage(named: "star_filled")

      }
    }
    saveButton?.image = image
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toDriverProfile" {
      if let vc = segue.destination as? ProfileViewController {
        vc.user = ride?.driver
        vc.mutualFriends = mutualFriends
        vc.ride = ride
      }
    }
  }

}

// MARK: - UITableViewDataSource
extension PassengerRideDetailsViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView!.dequeueReusableCell(withIdentifier: "driverCell", for: indexPath as IndexPath)

    if let driverCell = cell as? DriverTableViewCell {
      if let ride = ride {
        if let driver = ride.driver {
          if let imageURL = driver.imageURL {
            if let url = NSURL(string: imageURL) {
              driverCell.imageView?.setImageWith(url as URL, placeholderImage: UIImage(named: "empty_profile"))
            }
          }

          driverCell.name?.text = driver.getFullName()
        }
      }
    }

    return cell
  }

  func makeMutualFriendsRequest() {
    let params = ["fields": "context.fields(mutual_friends)"]
    if let id = ride?.driver?.facebookId {
      let path: String = "/\(id)"

      let request = FBSDKGraphRequest(graphPath: path, parameters: params, httpMethod: "GET")
      _ = request?.start { (connection, result, error) -> Void in
        if let error = error {
          print(error.localizedDescription)
        } else {
          if let result = result as? NSDictionary {
            if let context = result.object(forKey: "context") as? NSMutableDictionary {
              if let mutualFriends = context.object(forKey: "mutual_friends") as? NSMutableDictionary {
                if let data = mutualFriends.object(forKey: "data") as? NSMutableArray {
                  for user in data {
                    if let user = user as? NSMutableDictionary {
                      if let id = user["id"] as? String {
                        if let name = user["name"] as? String {
                          self.mutualFriends.append(User(facebookId: id, name: name))
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

}
