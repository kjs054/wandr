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
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: registeredContacts, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "registeredContacts")
            UserDefaults.standard.synchronize()
        } catch {
            print("Couldn't Save Contacts Data")
        }
    }
    
    func clearData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    func loadRegisteredContacts() -> [SelectableContact]? {
        do {
            if UserDefaults.standard.object(forKey: "registeredContacts") != nil{
                let decodedData = UserDefaults.standard.object(forKey: "registeredContacts") as! Data
                if let decodedPlace = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData) as? [SelectableContact] {
                    return decodedPlace
                }
            }
        }
        catch {
            print("Couldn't Fetch User Data")
        }
        return nil
    }
    
    func saveCurrentUserData(userData: Dictionary<String,String>) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: userData, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "currentUserData")
            UserDefaults.standard.synchronize()
        } catch {
            print("Couldn't Save User Data")
        }
    }
    
    func currentUserData() -> Dictionary<String,String>? {
        do {
            if UserDefaults.standard.object(forKey: "currentUserData") != nil{
                let decodedData = UserDefaults.standard.object(forKey: "currentUserData") as! Data
                if let decodedPlace = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData) as? Dictionary<String, String> {
                    return decodedPlace
                }
            }
        }
        catch {
            print("Couldn't Fetch User Data")
        }
        return nil
    }
}