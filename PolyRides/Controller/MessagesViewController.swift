//
//  MessagesViewController.swift
//  PolyRides
//
//  Created by Max Parelius on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import UIKit
import Foundation
import JSQMessagesViewController

class MessagesViewController: UIViewController {
  
  @IBOutlet weak var nameButton: UIButton!
//
//  var sender: User?
//  var recever: User?
//  var messages = [Message]()
//  var avatars = Dictionary<String, JSQMessagesAvatarImage>()
//  var incomingBubbleImageView = JSQMessagesBubbleImageFactory()
//    .incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
//  var outgoingBubbleImageView = JSQMessagesBubbleImageFactory()
//    .outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
//
//  func sendMessage(text: String!, sender: String!) {
//  }
//
//  func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
//    if let stringUrl = imageUrl {
//      if let url = NSURL(string: stringUrl) {
//        if let data = NSData(contentsOfURL: url) {
//          let image = UIImage(data: data)
//          let diameter = incoming ? UInt(collectionView!.collectionViewLayout
//            .incomingAvatarViewSize.width) :
//            UInt(collectionView!.collectionViewLayout.outgoingAvatarViewSize.width)
//          let avatarImage = JSQMessagesAvatarImageFactory
//            .avatarImageWithImage(image, diameter: diameter)
//          avatars[name] = avatarImage
//          return
//        }
//      }
//    }
//    setupAvatarColor(name, incoming: incoming)
//  }
//
//  func setupAvatarColor(name: String, incoming: Bool) {
//    let diameter = incoming ? UInt(collectionView!
//      .collectionViewLayout.incomingAvatarViewSize.width) :
//      UInt(collectionView!.collectionViewLayout.outgoingAvatarViewSize.width)
//
//    let rgbValue = name.hash
//    let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
//    let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
//    let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
//    let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
//
//    let nameLength = name.characters.count
//    let initials: String? = name.substringToIndex(name.startIndex.advancedBy(min(3, nameLength)))
//    let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(
//      initials, backgroundColor: color, textColor: UIColor.blackColor(),
//      font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
//
//    avatars[name] = userImage
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
////    inputToolbar!.contentView!.leftBarButtonItem = nil
////    automaticallyScrollsToMostRecentMessage = true
////    senderDisplayName = self.sender?.id
////    senderId = self.sender?.id
////    var senderImageUrl = self.sender?.imageURL
////    if let urlString = senderImageUrl {
////      setupAvatarImage((self.sender?.firstName)!, imageUrl: urlString, incoming: false)
////      senderImageUrl = urlString
////    } else {
////      setupAvatarColor((self.sender?.firstName)!, incoming: false)
////      senderImageUrl = ""
////    }
//
//    let backItem = UIBarButtonItem()
//    backItem.title = ""
//    navigationItem.backBarButtonItem = backItem
//  }
//
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    collectionView!.collectionViewLayout.springinessEnabled = true
//    scrollToBottomAnimated(true)
//  }
//
//  override func viewWillDisappear(animated: Bool) {
//    super.viewWillDisappear(animated)
//  }
//
//  func receivedMessagePressed(sender: UIBarButtonItem) {
//    showTypingIndicator = !showTypingIndicator
//    scrollToBottomAnimated(true)
//  }
//
//  override func didPressSendButton(button: UIButton!, withMessageText text: String!,
//                                   senderId: String!, senderDisplayName: String!,
//                                   date: NSDate!) {
//    JSQSystemSoundPlayer.jsq_playMessageSentSound()
//    sendMessage(text, sender: senderId)
//    finishSendingMessage()
//  }
//
//  override func collectionView(collectionView: JSQMessagesCollectionView!,
//                               messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
//    return messages[indexPath.item]
//  }
//
//  override func collectionView(collectionView: JSQMessagesCollectionView!,
//                               messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!)
//  -> JSQMessageBubbleImageDataSource! {
//      let message = messages[indexPath.item]
//      if message.senderId() == senderId {
//        return outgoingBubbleImageView
//      }
//      return incomingBubbleImageView
//  }
//
//  override func collectionView(collectionView: JSQMessagesCollectionView!,
//                               avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!)
//    -> JSQMessageAvatarImageDataSource! {
//    let message = messages[indexPath.item]
//    if message.senderId() == senderId {
//      return nil
//    }
//    if indexPath.item > 0 {
//      let previousMessage = messages[indexPath.item - 1]
//      if previousMessage.senderId() == message.senderId() {
//        return nil
//      }
//    }
//    if let sender = message.senderId() {
//      if let avatar = avatars[sender] {
//        return avatar
//      } else {
//        setupAvatarImage(sender, imageUrl: message.imageUrl(), incoming: true)
//        return avatars[sender]
//      }
//    }
//    return nil
//  }
//
//  override func collectionView(collectionView: UICollectionView,
//                               numberOfItemsInSection section: Int) -> Int {
//    return messages.count
//  }
//
//  override func collectionView(collectionView: UICollectionView,
//                               cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//    if let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as?
//      JSQMessagesCollectionViewCell {
//      let message = messages[indexPath.item]
//      if message.senderId() == senderId {
//        cell.textView!.textColor = UIColor.blackColor()
//      } else {
//        cell.textView!.textColor = UIColor.whiteColor()
//      }
//
//      let attributes = [NSForegroundColorAttributeName:(cell.textView!.textColor!),
//                        NSUnderlineStyleAttributeName:1, NSFontAttributeName:"Avenir"]
//      cell.textView!.linkTextAttributes = attributes
//      return cell
//    }
//    return UICollectionViewCell()
//  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPopover" {
      let popoverViewController = segue.destination
      popoverViewController.modalPresentationStyle = .popover
      popoverViewController.preferredContentSize = CGSize(width: 275, height: 173)
      if let popoverPresentationController = popoverViewController.popoverPresentationController {
        popoverPresentationController.delegate = self
        nameButton.sizeToFit()
        popoverPresentationController.sourceRect = nameButton.frame
      }
    }
  }

  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController)
    -> UIModalPresentationStyle {
    return UIModalPresentationStyle.none
  }

}

// MARK: UIPopoverPresentationControllerDelegate
extension MessagesViewController: UIPopoverPresentationControllerDelegate {

  func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

  }

}
