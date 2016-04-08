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

  var mutualFriends = [User]()

  @IBOutlet weak var tableView: UITableView?
  @IBOutlet weak var saveButton: UIBarButtonItem?

  @IBAction func saveRideAction(sender: AnyObject) {
    if let ride = ride {
      let index = user?.savedRides.indexOf({ $0.id == ride.id })
      if let index = index {
        let title = "Are you sure you want to remove this ride from saved?"
        presentAlert(AlertOptions(title: title, message: "", handler: { action in
          self.user?.savedRides.removeAtIndex(index)
          self.rideService.removeFromSaved(self.user, ride: ride)
          self.setSavedIcon()
        }, showCancel: true))
      } else {
        user?.savedRides.append(ride)
        rideService.addToSaved(self.user, ride: ride)
        setSavedIcon()
      }
    } else {
      let title = "Saving Error"
      let message = "There was an error adding to your saved rides. Please try again."
      presentAlert(AlertOptions(message: message, title: title))
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.dataSource = self
    makeMutualFriendsRequest()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    setSavedIcon()
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  func setSavedIcon() {
    var image = UIImage(named: "star")
    if let ride = ride {
      if user?.savedRides.indexOf({ $0.id == ride.id }) != nil {
        image = UIImage(named: "star_filled")
      }
    }
    saveButton?.image = image
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toDriverProfile" {
      if let vc = segue.destinationViewController as? ProfileViewController {
        vc.user = ride?.driver
        vc.mutualFriends = mutualFriends
      }
    }
  }

}

// MARK: - UITableViewDataSource
extension PassengerRideDetailsViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("driverCell", forIndexPath: indexPath)

    if let driverCell = cell as? DriverTableViewCell {
      if let driver = ride?.driver {
        if let imageURL = driver.imageURL {
          if let url = NSURL(string: imageURL) {
            driverCell.imageView?.setImageWithURL(url, placeholderImage: UIImage(named: "empty_profile"))
          }
        }

        driverCell.name?.text = driver.getFullName()
      }
    }

    return cell
  }

  func makeMutualFriendsRequest() {
    let params = ["fields": "context.fields(mutual_friends)"]
    if let id = ride?.driver?.facebookId {
      let path: String = "/\(id)"

      let request = FBSDKGraphRequest(graphPath: path, parameters: params, HTTPMethod: "GET")
      request.startWithCompletionHandler { (connection, result, error) -> Void in
        if error == nil {
          if let context = result.objectForKey("context") as? NSMutableDictionary {
            if let mutualFriends = context.objectForKey("mutual_friends") as? NSMutableDictionary {
              if let data = mutualFriends.objectForKey("data") as? NSMutableArray {

                for user in data {
                  if let id = user["id"] as? String {
                    if let name = user["name"] as? String {
                      self.mutualFriends.append(User(facebookId: id, name: name))
                    }
                  }
                }
              }
            }
          }
        } else {
          print(error)
        }
      }
    }
  }

}
