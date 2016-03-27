//
//  RegionRidesViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import DZNEmptyDataSet

class RegionRidesViewController: RidesViewController {

  var region: Region?
  var toRides: [Ride]?
  var fromRides: [Ride]?

  @IBOutlet weak var segmentedControl: UISegmentedControl?

  @IBAction func segmentedControlAction(sender: AnyObject) {
    if let segmentedControl = sender as? UISegmentedControl {
      if segmentedControl.selectedSegmentIndex == 0 {
        rides = fromRides
      } else {
        rides = toRides
      }
    }
    tableView?.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    rides = fromRides
    tableView?.delegate = self
    tableView?.emptyDataSetSource = self

    // Remove the cell separators in the empty table view.
    tableView?.tableFooterView = UIView()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toPassengerRideDetails" {
      if let tabVC = segue.destinationViewController as? UITabBarController {
        if let navVC = tabVC.viewControllers?.first as? UINavigationController {
          if let vc = navVC.topViewController as? RideDetailsViewController {
            if let cell = sender as? RideTableViewCell {
              vc.ride = cell.ride
              vc.user = user
            }
          }
        }
      }
    }
  }

}

// MARK: - UITableViewDelegate
extension RegionRidesViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

}

// MARK: - DZNEmptyDataSetDataSource
extension RegionRidesViewController: DZNEmptyDataSetSource {

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
    return NSAttributedString(string: "No rides were found", attributes: attributes)
  }

  func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    var message = ""
    if let title = title {
      if title == "Other" {
        message = "There are no other rides, try checking back in a little while."
      } else {
        var displayTitle = title
        if displayTitle == "Central Coast" {
          displayTitle = "the Central Coast"
        } else if title == "SF Bay" {
          displayTitle = "the SF Bay Area"
        }

        if segmentedControl?.selectedSegmentIndex == 0 {
          message = "There are no rides leaving from \(displayTitle), try checking back in a little while."
        } else {
          message = "There are no rides going to \(displayTitle), try checking back in a little while."
        }
      }
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
