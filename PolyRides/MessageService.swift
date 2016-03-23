//
//  MessageService.swift
//  PolyRides
//
//  Created by Max Parelius on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

class MessageService {
  var messageDeligate: MessageDeligate?
  let ref = FirebaseConnection.service.ref

  func getMessagesForConversation(convo: Conversation) {
  }
}
