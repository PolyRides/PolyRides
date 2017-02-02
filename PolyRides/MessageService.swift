//
//  MessageService.swift
//  PolyRides
//
//  Created by Max Parelius on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

protocol FirebaseMessageDelegate {
  
}

class MessageService {
  let ref = FIRDatabase.database().reference()

  func getMessagesForConversation(convo: Conversation) {
  }
}
