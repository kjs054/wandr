//
//  message.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/23/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Message {
    var sender: User
    var timestamp: Timestamp
    var content: String
    var type: Type
    var isFromCurrentLoggedInUser: Bool
    
    init(dictionary: [String: Any]) {
        self.sender = dictionary["sender"] as! User
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.content = dictionary["content"] as? String ?? ""
        self.type = getType(type: dictionary["type"] as! String)
        self.isFromCurrentLoggedInUser = Auth.auth().currentUser?.uid == self.sender.uid
    }
}

enum Type {
    case text
    case place
    case waze
    case openTable
    case facebook
    case uber
}

func getType(type: String) -> Type {
    switch type {
    case "text":
        return .text
    default:
        return .text
    }
}
