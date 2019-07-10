//
//  LocalStorage.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

class LocalStorage {
    
    static  let sharedInstance  = LocalStorage()
    public init() {}
    
    // MARK: User
    func saveRegisteredContact(registeredContacts: [SelectableContact]){
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: registeredContacts)
        defaults.set(data, forKey: "registeredContacts")
    }
    
    func clearData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    func loadRegisteredContacts() -> [SelectableContact]? {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "registeredContacts") as? NSData {
            let savedRegisteredContacts = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [SelectableContact]
            return savedRegisteredContacts
        }
        return nil
    }
}
