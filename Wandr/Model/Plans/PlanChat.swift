//
//  PlanChat.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/23/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

struct PlanChat {
    var name: String
    var members: [User]
    var messages: [Message]
    var created: Date
}
