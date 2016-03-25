//
//  ConversationService.swift
//  PolyRides
//
//  Created by Max Parelius on 3/21/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Firebase

protocol ConversationDeligate: class {
}

class ConversationService {

  var conversationDeligate: ConversationDeligate?
  let ref = FirebaseConnection.ref

  func pushConversationToFirebase(convo: Conversation) {
    let convoRef = ref.childByAppendingPath("conversations").childByAutoId()
    if let driverId = convo.driver?.id {
      if let passengerId = convo.passenger?.id {
        let driverConvoRef = ref.childByAppendingPath("users/\(driverId)/conversations/\(convoRef.key)")
        let passengerConvoRef = ref.childByAppendingPath("users/\(passengerId)/conversations/\(convoRef.key)")
        driverConvoRef.setValue(true)
        passengerConvoRef.setValue(true)
        convoRef.setValue(convo.toAnyObject())
      }
    }
  }

}
