//
//  RegistrationHandlers.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/25/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Contacts

fileprivate let db = Firestore.firestore()

protocol firebaseFunctions {
    func uploadProfileImageToStorage(image: UIImage, complete:@escaping ()->())
    func addUserDataToUsersCollection()
}

extension firebaseFunctions {
    
    //MARK:- Logic
    func uploadProfileImageToStorage(image: UIImage, complete:@escaping ()->()) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profileImages/\(newUserData["uid"]!)")
        if let uploadData = (image).pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url?.absoluteString else {
                        print(error!)
                        return
                    }
                    newUserData["profileImageURL"] = downloadURL
                    complete()
                    print(downloadURL)

                })
            }
        }
    }
    
    func addUserDataToUsersCollection() {
        guard let uid = newUserData["uid"] else {
            print("Error: No valid UID!")
            return
        }
        db.collection("users").document(uid).setData(newUserData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                self.getContacts(uid)
                self.savePhoneNumberToRegisteredPhonesCollection(uid)
                print("Document Written Successfully")
            }
        }
    }
    
    func savePhoneNumberToRegisteredPhonesCollection(_ uid: String) {
        guard let phoneNumber = newUserData["phoneNumber"] else {
            print("Couldnt get phone number")
            return
        }
        db.collection("registeredPhones").document(phoneNumber).setData(["uid": uid])
    }
    
    fileprivate func getContacts(_ uid: String) {
        let cn = CNContactStore()
        cn.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to Request Access:", err)
                return
            }
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] //Gets name, last name, and phone number(s)
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try cn.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        let phone = contact.phoneNumbers.first?.value.stringValue ?? "" //get first phone number
                        let name = "\(contact.givenName) \(contact.familyName)" //combine first and last name
                        if contact.givenName.isEmpty || phone.isEmpty { //if the contact is missing data don't add to array of contacts
                            return
                        } else {
                            if let formattedPhone = phone.formatPhone() {
                                self.addDataToContactsSubCollection(uid, formattedPhone, name)
                            }
                        }
                    })
                } catch let err {
                    print(err)
                }
            } else {
                print("Denied")
            }
        }
    }
    
    fileprivate func addDataToContactsSubCollection(_ uid: String, _ formattedPhone: String, _ name: String) {
        let ref = db.collection("registeredPhones").document(formattedPhone)
        ref.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    let uidFromDatabase = snapshot.get("uid") as! String
                    let contactData = ["uid": uidFromDatabase]
                    db.collection("users").document(uid).collection("contacts").document(formattedPhone).setData(contactData)
                } else {
                    return
                }
            }
        }
    }
    
    fileprivate func sendCurrentUserToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error)
                return;
            }
            
        }
    }
}

extension ProfileImageInputController: firebaseFunctions {}
