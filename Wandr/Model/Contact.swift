//
//  Contact.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/19/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

var userContacts = [SelectableContact]()

struct SelectableContact {
    var name: String
    var phoneNum: String
    var selected: Bool
}
