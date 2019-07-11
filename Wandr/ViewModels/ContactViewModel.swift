//
//  ContactViewModel.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/9/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import UIKit
class ContactViewModel {
    
    var name: String
    var phoneNum: String
    var uid: String?
    var selected: Bool
    
    init(contact: SelectableContact) {
        self.name = contact.name; self.phoneNum = contact.phoneNum; self.uid = contact.uid; self.selected = contact.selected;
    }
}
