//
//  ContactViewModel.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/9/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

class ContactViewModel {
    var name: String
    var phoneNum: String
    var uid: String?
    var selected: Bool
    
    init(name: String, phoneNum: String, uid: String?, selected: Bool) {
        self.name = name; self.phoneNum = phoneNum; self.uid = uid; self.selected = selected
    }
}
