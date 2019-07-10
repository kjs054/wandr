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
    func checkIfContactIsUser(contact: SelectableContact, callback: @escaping ((_ uid:String) ->Void ))
    func fetchUserData(completionHandler: @escaping (_ userExists: Bool) -> ())
}

extension firebaseFunctions {
    
    //MARK:- Logic
    func uploadProfileImageToStorage(image: UIImage, complete:@escaping ()->()) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profileImages/\(getUID())")
        if let uploadData = image.jpeg(.medium) {
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
                } catch let err {
                    print(err)
                }
            } else {
                print("Denied")
            }
        }
        return userContacts
    }
    
    func checkIfContactIsUser(contact: SelectableContact, callback: @escaping ((_ uid:String) ->Void ))  {
        let ref = db.collection("registeredPhones").document(contact.phoneNum)
        ref.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    let uidForContact = snapshot.get("uid") as! String
                    let contactData = ["uid": uidForContact]
                    let ref = db.collection("users").document(self.getUID()).collection("contacts").document(contact.phoneNum)
                    ref.getDocument(completion: { (snapshot, error) in
                        if let snapshot = snapshot {
                            if snapshot.exists == false {
                                ref.setData(contactData)
                            }
                            callback(uidForContact)
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
    
    func fetchUserData(completionHandler: @escaping (_ userExists: Bool) -> ()) { //gets the users data from firestore and stores it in currentUser dictionary
        let localStorage = LocalStorage()
        let uid = getUID()
        let docRef = db.collection("users").document(uid) //Retrieves document named with users id
        docRef.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    let data = snapshot.data() as! [String : String]
                    localStorage.saveCurrentUserData(userData: data)
                    completionHandler(true)
                    //Perform element setup after fetching complete
                } else {
                    completionHandler(false)
                }
            }
        }
    }
}

extension NewPlanController: firebaseFunctions {}
extension ProfileImageInputController: firebaseFunctions {}
extension HomeController: firebaseFunctions {}
