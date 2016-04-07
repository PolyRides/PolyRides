//
//  MutualFriendsTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/3/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import DZNEmptyDataSet

class MutualFriendsTableViewController: UITableViewController {

  var mutualFriends: [User]?
  var otherUser: User?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.emptyDataSetSource = self

    // Remove the cell separators in the empty table view.
    tableView?.tableFooterView = UIView()
  }

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
          imageView.setImageWithURL(url, placeholderImage: UIImage(named: "empty_profile"))
          imageView.layer.cornerRadius = 25
          imageView.clipsToBounds = true
        }

      }

    }
    cell.textLabel?.text = friend.getFullName()

    return cell
  }

}

// MARK: - DZNEmptyDataSetSource
extension MutualFriendsTableViewController: DZNEmptyDataSetSource {

  func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: "empty")
  }

  func imageAnimationForEmptyDataSet(scrollView: UIScrollView!) -> CAAnimation! {
    let animation = CABasicAnimation(keyPath: "transform")

    animation.fromValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
    animation.duration = 0.25
    animation.cumulative = true
    animation.repeatCount = MAXFLOAT

    return animation
  }

  func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let attributes = [
      NSFontAttributeName: UIFont.systemFontOfSize(18),
      NSForegroundColorAttributeName : UIColor.blackColor()]
    let message = "No mutual friends."
    return NSAttributedString(string: message, attributes: attributes)
  }

  func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    var message = ""
    if let name = otherUser?.getFullName() {
      message = "You and \(name) don't have any mutual friends that use Poly Rides."
    }
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
    paragraph.alignment = NSTextAlignment.Center
    let attributes = [
      NSFontAttributeName: UIFont.systemFontOfSize(14),
      NSForegroundColorAttributeName: UIColor.grayColor(),
      NSParagraphStyleAttributeName: paragraph]

    return NSAttributedString(string: message, attributes: attributes)
  }

  func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
    return UIColor.whiteColor()
  }
}
