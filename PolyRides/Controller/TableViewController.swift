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

    // Remove the cell separators in the empty table view.
    tableView?.tableFooterView = UIView()
    tableView?.backgroundView = nil
    tableView?.backgroundColor = UIColor.white

    setupAppearance()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

}

// MARK: - DZNEmptyDataSetDataSource
extension TableViewController: DZNEmptyDataSetSource {

  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    if emptyImage == "" {
      return nil
    }
    return UIImage(named: emptyImage)
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
      NSFontAttributeName: Font.EmptyTableHeader,
      NSForegroundColorAttributeName : Color.Navy]
    return NSAttributedString(string: emptyTitle, attributes: attributes)
  }

  func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
    paragraph.alignment = NSTextAlignment.center
    let attributes = [
      NSFontAttributeName: Font.TableRowSubline,
      NSForegroundColorAttributeName: Color.Gray,
      NSParagraphStyleAttributeName: paragraph]

    return NSAttributedString(string: emptyMessage, attributes: attributes)
  }

  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return UIColor.white
  }
}
