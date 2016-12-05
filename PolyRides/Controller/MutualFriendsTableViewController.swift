
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

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let mutualFriends = mutualFriends {
      return mutualFriends.count
    }
    return 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let friend = mutualFriends![indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath as IndexPath)

    if let imageURL = friend.imageURL {
      if let url = NSURL(string: imageURL) {
        if let imageView = cell.imageView {
          imageView.setImageWith(url as URL, placeholderImage: UIImage(named: "empty_profile"))
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

  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: "empty")
  }

  func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
    let animation = CABasicAnimation(keyPath: "transform")

    animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
    animation.duration = 0.25
    animation.isCumulative = true
    animation.repeatCount = MAXFLOAT

    return animation
  }

  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let attributes = [
      NSFontAttributeName: UIFont.systemFont(ofSize: 18),
      NSForegroundColorAttributeName : UIColor.black]
    let message = "No mutual friends."
    return NSAttributedString(string: message, attributes: attributes)
  }

  func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    var message = ""
    if let name = otherUser?.getFullName() {
      message = "You and \(name) don't have any mutual friends that use Poly Rides."
    }
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
    paragraph.alignment = NSTextAlignment.center
    let attributes = [
      NSFontAttributeName: UIFont.systemFont(ofSize: 14),
      NSForegroundColorAttributeName: UIColor.gray,
      NSParagraphStyleAttributeName: paragraph]

    return NSAttributedString(string: message, attributes: attributes)
  }

  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return UIColor.white
  }
}
