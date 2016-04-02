//
//  PassengerRideDetailsViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class DriverTableViewCell: UITableViewCell {

  var driver: User?

  @IBOutlet weak var driverImageView: UIImageView?
  @IBOutlet weak var name: UILabel?

}

class PassengerRideDetailsViewController: RideDetailsViewController {

  let rideService = RideService()

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
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    setSavedIcon()
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
    if segue.identifier == "toDriverDetails" {
      if let vc = segue.destinationViewController as? ProfileViewController {
        vc.user = ride?.driver
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

        driverCell.driver = driver
        driverCell.name?.text = driver.getFullName()
      }
    }

    return cell
  }

}
