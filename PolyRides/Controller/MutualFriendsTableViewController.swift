//
//  MutualFriendsTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/3/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class MutualFriendsTableViewController: UITableViewController {

  var mutualFriends: [User]?

}

// MARK: - UITableViewDataSource
extension MutualFriendsTableViewController {

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let mutualFriends = mutualFriends {
      return mutualFriends.count
    }
    return 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let friend = mutualFriends![indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)

    if let imageURL = friend.imageURL {
      if let url = NSURL(string: imageURL) {
        if let imageView = cell.imageView {
          print(imageView.frame.size)
          imageView.layer.cornerRadius = 25
          imageView.clipsToBounds = true
          imageView.setImageWithURL(url, placeholderImage: UIImage(named: "empty_profile"))
        }

      }

    }
    cell.textLabel?.text = friend.getFullName()

    return cell
  }
}
