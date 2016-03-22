//
//  Message.swift
//  PolyRides
//
//  Created by Max Parelius on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation
import JSQMessagesViewController

protocol MessageDeligate: class {

  func onMessagesReceived(messages: [Message])
}

class Message: NSObject, JSQMessageData {
  var conversationVar: String
  var senderIdVar: String
  var receivedVar: Bool
  var textVar: String
  var dateVar: NSDate
  var imageUrlVar: String?

  convenience init(conversation: String?, senderId: String?, received: Bool?, message: String?,
    timestamp: NSDate?) {
      self.init(conversation: conversation, senderId: senderId, received: received, message: message,
        timestamp: timestamp, imageUrl: nil)
  }

  init(conversation: String?, senderId: String?, received: Bool?, message: String?,
    timestamp: NSDate?, imageUrl: String?) {
    self.conversationVar = conversation!
    self.senderIdVar = senderId!
    self.receivedVar = received!
    self.textVar = message!
    self.dateVar = timestamp!
    self.imageUrlVar = imageUrl
  }

  func isMediaMessage() -> Bool {
    return false
  }

  func messageHash() -> UInt {
    let signed = rand()
    let unsigned = signed >= 0 ?
      UInt(signed) :
      UInt(signed  - Int.min) + UInt(Int.max) + 1
    return unsigned
  }

  func conversation() -> String! {
    return conversationVar
  }

  func received() -> Bool! {
    return receivedVar
  }

  func text() -> String! {
    return textVar
  }

  func date() -> NSDate! {
    return dateVar
  }

  func imageUrl() -> String? {
    return imageUrlVar
  }

  func senderId() -> String! {
    return senderIdVar
  }

  func senderDisplayName() -> String! {
    return senderIdVar
  }
}
