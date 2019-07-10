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
    var uid: String?
    var selected: Bool
    
    init(name: String, phoneNum: String, uid: String?, selected: Bool) {
        self.name = name; self.phoneNum = phoneNum; self.uid = uid; self.selected = selected;
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject (forKey: "name") as? String ?? ""
        self.phoneNum = decoder.decodeObject  (forKey: "phoneNum") as? String ?? ""
        self.uid = decoder.decodeObject  (forKey: "uid") as? String ?? ""
        self.selected = decoder.decodeBool  (forKey: "selected")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name,           forKey: "name")
        aCoder.encode(self.uid,     forKey: "uid")
        aCoder.encode(self.phoneNum,     forKey: "phoneNum")
        aCoder.encode(self.selected,    forKey: "selected")
    }
}
