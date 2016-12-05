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

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath as IndexPath)

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
