//
//  Contact.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/19/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

class SelectableContact: NSObject, NSCoding {
    var name: String
    var phoneNum: String
    var selected: Bool
    var userData: user?
    
    init(name: String, phoneNum: String, userData: user?, selected: Bool) {
        self.name = name; self.phoneNum = phoneNum; self.userData = userData; self.selected = selected;
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject (forKey: "name") as? String ?? ""
        self.phoneNum = decoder.decodeObject  (forKey: "phoneNum") as? String ?? ""
        self.selected = decoder.decodeBool  (forKey: "selected")
        self.userData = decoder.decodeObject(forKey: "userData") as? user
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name,           forKey: "name")
        aCoder.encode(self.userData,     forKey: "userData")
        aCoder.encode(self.phoneNum,     forKey: "phoneNum")
        aCoder.encode(self.selected,    forKey: "selected")
    }
}
