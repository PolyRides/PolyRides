//
//  TableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/5/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import DZNEmptyDataSet

class TableViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView?

  var emptyImage = ""
  var emptyTitle = ""
  var emptyMessage = ""

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView?.emptyDataSetSource = self
    setupAppearance()

    // Remove the cell separators in the empty table view.
    tableView?.tableFooterView = UIView()
  }

}

// MARK: - DZNEmptyDataSetDataSource
extension TableViewController: DZNEmptyDataSetSource {

  func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
    if emptyImage == "" {
      return nil
    }
    return UIImage(named: emptyImage)
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
      NSFontAttributeName: Font.EmptyTableHeader,
      NSForegroundColorAttributeName : Color.Blue]
    return NSAttributedString(string: emptyTitle, attributes: attributes)
  }

  func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
    paragraph.alignment = NSTextAlignment.Center
    let attributes = [
      NSFontAttributeName: Font.TableRowSubline,
      NSForegroundColorAttributeName: Color.DarkGray,
      NSParagraphStyleAttributeName: paragraph]

    return NSAttributedString(string: emptyMessage, attributes: attributes)
  }

  func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
    return Color.LightGray
  }
}
