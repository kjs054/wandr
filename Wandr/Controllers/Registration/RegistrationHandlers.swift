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
    func getContacts() -> [SelectableContact]
    func checkIfContactIsUser(phone: String, callback: @escaping ((_ uid:String) ->Void ))
}

extension firebaseFunctions {
    
    //MARK:- Logic
    func uploadProfileImageToStorage(image: UIImage, complete:@escaping ()->()) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profileImages/\(getUID())")
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
        db.collection("users").document(getUID()).setData(newUserData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                self.savePhoneNumberToRegisteredPhonesCollection(self.getUID())
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
    
    func getContacts() -> [SelectableContact] {
        var userContacts = [SelectableContact]()
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
                                userContacts.append(SelectableContact(name: name, phoneNum: formattedPhone, uid: nil, selected: false))
                            }
                        }
                    })
                    print(userContacts)
                } catch let err {
                    print(err)
                }
            } else {
                print("Denied")
            }
        }
        return userContacts
    }
    
    func checkIfContactIsUser(phone: String, callback: @escaping ((_ uid:String) ->Void ))  {
        let ref = db.collection("registeredPhones").document(phone)
        ref.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    let uidForContact = snapshot.get("uid") as! String
                    let contactData = ["uid": uidForContact]
                    let ref = db.collection("users").document(self.getUID()).collection("contacts").document(phone)
                    ref.getDocument(completion: { (snapshot, error) in
                        if let snapshot = snapshot {
                            if snapshot.exists {
                                callback(uidForContact)
                            } else {
                                callback(uidForContact)
                                ref.setData(contactData)
                            }
                        }
                    })
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
    
    fileprivate func getUID() -> String {
        let auth = Auth.auth()
        guard let uid = auth.currentUser?.uid else {
            fatalError("NO USER ID")
        }
        return uid
    }
}

extension NewPlanController: firebaseFunctions {}
extension ProfileImageInputController: firebaseFunctions {}
