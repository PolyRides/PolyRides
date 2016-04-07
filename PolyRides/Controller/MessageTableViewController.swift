//
//  MessageTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/30/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class ConversationTableViewCell: UITableViewCell {

  @IBOutlet weak var unreadView: UIView?
  @IBOutlet weak var initialsView: UIView?
  @IBOutlet weak var initialsLabel: UILabel?
  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var dateLabel: UILabel?
  @IBOutlet weak var messageLabel: UILabel?

  var conversation: Conversation?
}

class ConversationTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    setupAppearance()
  }

}


// MARK: - UITableViewDataSource
extension ConversationTableViewController {

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath)

    if let cell = cell as? ConversationTableViewCell {
      if let unreadView = cell.unreadView {
        cell.unreadView?.layer.cornerRadius = unreadView.frame.size.height / 2
      }
      if let initialsView = cell.initialsView {
          cell.initialsView?.layer.cornerRadius = initialsView.frame.size.height / 2
      }
    }

    return cell
  }

}
