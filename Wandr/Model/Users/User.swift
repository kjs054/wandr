//
//  File.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject, NSCoding {
    var name: String
    var profileImageURL: String
    var phoneNumber: String
    var uid: String
    var displayColor: UIColor?
    
    init(name: String, profileImageURL: String, phoneNumber: String, uid: String) {
        self.name = name; self.phoneNumber = phoneNumber; self.uid = uid; self.profileImageURL = profileImageURL;
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject (forKey: "name") as? String ?? ""
        self.phoneNumber = decoder.decodeObject  (forKey: "phoneNumber") as? String ?? ""
        self.uid = decoder.decodeObject(forKey: "uid") as? String ?? ""
        self.profileImageURL = decoder.decodeObject(forKey: "profileImageURL") as? String ?? ""
    }
    
    func getUserColor(index: Int) {
        switch index {
        case 0: self.displayColor = #colorLiteral(red: 0.1803921569, green: 0.8352941176, blue: 0.4509803922, alpha: 1)
        case 1: self.displayColor = #colorLiteral(red: 0.8039215686, green: 0.5176470588, blue: 0.9450980392, alpha: 1)
        case 2: self.displayColor = #colorLiteral(red: 1, green: 0.6862745098, blue: 0.3537920122, alpha: 1)
        case 3: self.displayColor = #colorLiteral(red: 1, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        case 4: self.displayColor = #colorLiteral(red: 1, green: 0.8666666667, blue: 0.3490196078, alpha: 1)
        case 5: self.displayColor = #colorLiteral(red: 0, green: 0.8125218372, blue: 0.7882352941, alpha: 1)
        case 6: self.displayColor = #colorLiteral(red: 0.9921568627, green: 0.4745098039, blue: 0.6588235294, alpha: 1)
        default: self.displayColor = UIColor.gray
        }
    }
    
    func toSelectableContact() -> SelectableContact {
        return SelectableContact(name: self.name, phoneNum: self.phoneNumber, userData: self, selected: false)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.uid, forKey: "uid")
        aCoder.encode(self.profileImageURL, forKey: "profileImageURL")
    }
}

extension User: Fetchable {
    static var apiBase: String { return "users" }
}
