////
////  Message.swift
////  PolyRides
////
////  Created by Max Parelius on 3/19/16.
////  Copyright © 2016 Vanessa Forney. All rights reserved.
////
//
//import Foundation
//import JSQMessagesViewController
//
//protocol MessageDelegate: class {
//
//  func onMessagesReceived(messages: [Message])
//}
//
//class Message: JSQMessage {
//
//  var id: String?
//  var conversationVar: String?
//  var senderIdVar: String?
//  var receivedVar: Bool?
//  var textVar: String?
//  var dateVar: Date?
//  var imageUrlVar: String?
//
//  init(message: String, timestamp: Date, senderId: String) {
//    super.init()
//    self.senderIdVar = senderId
//    self.textVar = message
//    self.dateVar = timestamp
//  }
//
//  override func isMediaMessage() -> Bool {
//    return false
//  }
//
//  func conversation() -> String? {
//    return conversationVar
//  }
//
//  func received() -> Bool? {
//    return receivedVar
//  }
//
//  func text() -> String? {
//    return textVar
//  }
//
//  func date() -> Date! {
//    return dateVar
//  }
//
//  func imageUrl() -> String? {
//    return imageUrlVar
//  }
//
//  func senderId() -> String? {
//    return senderIdVar
//  }
//
//  func senderDisplayName() -> String? {
//    return senderIdVar
//  }
//}
//
