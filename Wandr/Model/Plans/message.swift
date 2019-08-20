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
    var messageID: String
    
    init(dictionary: [String: Any]) {
        self.sender = dictionary["sender"] as! User
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.content = dictionary["content"] as! String
        self.type = Type(rawValue: dictionary["type"] as! String)!
        self.messageID = dictionary["messageID"] as! String
        self.isFromCurrentLoggedInUser = Auth.auth().currentUser?.uid == self.sender.uid
    }
    
    func getDisplayText() -> String {
        let senderName = self.isFromCurrentLoggedInUser ? "You" : self.sender.name
        switch self.type {
        case .text:
            return "\(senderName): \(self.content)"
        case .info(.created):
            return "\(senderName) created a plan"
        case .info(.invitedMember):
            return "\(senderName) invited \(self.content)"
        case .info(.renamed):
            return"\(senderName) named the plan '\(self.content)'"
        case .info(.deleted):
            return "\(senderName) deleted a message"
        case .info(.memberLeft):
            return "\(senderName) left the plan"
        default:
            return ""
        }
    }
}

enum infoType {
    case created, renamed, invitedMember, memberLeft, deleted
}

enum planType {
    case event, concert, place
}

enum Type {
    case text
    case info(infoType)
    case plan(planType)
    case waze
    case openTable
    case uber
}

extension Type: RawRepresentable {
    
    public typealias RawValue = String
    
    /// Failable Initalizer
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "created":  self = .info(.created)
        case "renamed":  self = .info(.renamed)
        case "invitedMember": self = .info(.invitedMember)
        case "memberLeft": self = .info(.memberLeft)
        case "concert": self = .plan(.concert)
        case "place": self = .plan(.place)
        case "event": self = .plan(.event)
        case "text": self = .text
        case "uber": self = .uber
        case "deleted": self = .info(.deleted)
        default:
            return nil
        }
    }
    
    /// Backing raw value
    public var rawValue: RawValue {
        switch self {
        case .info(.created):     return "created"
        case .info(.renamed):   return "renamed"
        case .info(.invitedMember): return "invitedMember"
        case .info(.memberLeft): return "memberLeft"
        case .info(.deleted): return "deleted"
        case .plan(.concert): return "concert"
        case .plan(.place): return "place"
        case .plan(.event): return "event"
        case .text: return "text"
        case .uber: return "uber"
        case .waze: return "waze"
        case .openTable: return "openTable"
        }
    }
    
}
