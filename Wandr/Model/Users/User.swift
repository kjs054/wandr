//
//  File.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

class user: NSObject, NSCoding {
    var name: String
    var profileImageURL: String
    var phoneNumber: String
    var uid: String
    
    init(name: String, profileImageURL: String, phoneNumber: String, uid: String) {
        self.name = name; self.phoneNumber = phoneNumber; self.uid = uid; self.profileImageURL = profileImageURL;
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject (forKey: "name") as? String ?? ""
        self.phoneNumber = decoder.decodeObject  (forKey: "phoneNumber") as? String ?? ""
        self.uid = decoder.decodeObject(forKey: "uid") as? String ?? ""
        self.profileImageURL = decoder.decodeObject(forKey: "profileImageURL") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.uid, forKey: "uid")
        aCoder.encode(self.profileImageURL, forKey: "profileImageURL")
    }
}
