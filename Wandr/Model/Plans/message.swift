//
//  message.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/23/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

struct Message {
    var sender: user
    var timestamp: Date
    var content: String
    var type: Type
}

enum Type {
    case text
    case place
    case waze
    case openTable
    case facebook
    case uber
}
