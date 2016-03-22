//
//  Conversation.swift
//  PolyRides
//
//  Created by Max Parelius on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

protocol ConversationDeligate: class {

  func onConversationsReceived(conversations: [Conversation])
}

class Conversation {

  var id: String?
  var timestamp: NSDate?
  var lastUpdated: NSDate?
  var lastMessage: Message?
  var ride: Ride?
  var driver: User?
  var driverIsTyping: Bool?
  var passenger: User?
  var passengerIsTyping: Bool?
  var messages: [String]?
}
