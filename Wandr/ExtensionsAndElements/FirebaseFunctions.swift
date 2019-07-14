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
    func addUserDataToUsersCollection(complete:@escaping ()->())
    func getContacts(callback:@escaping (_ contacts: [SelectableContact]) -> ())
    func checkIfContactIsUser(contact: SelectableContact, callback: @escaping ((_ uid:String?) ->Void ))
    func fetchCurrentUserData(uid: String, completionHandler: @escaping (_ userData: Dictionary<String, String>?) -> ())
    func getUID() -> String
}

extension firebaseFunctions {
    
    //MARK:- Logic
    func uploadProfileImageToStorage(image: UIImage, complete:@escaping ()->()) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profileImages/\(getUID())")
        if let uploadData = image.jpeg(.low) {
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
    
    func addUserDataToUsersCollection(complete:@escaping ()->()) {
        db.collection("users").document(getUID()).setData(newUserData) { err in
            if let err = err {
                fatalError("\(err)")
            } else {
                self.savePhoneNumberToRegisteredPhonesCollection(self.getUID())
                print("Document Written Successfully")
                complete()
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
    
    func getContacts(callback: @escaping (_ contacts: [SelectableContact]) -> ()) {
        let localStorage = LocalStorage()
        var userContacts = [SelectableContact]()
        var phonesArray = [String]()
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
                        if phonesArray.contains(phone) {
                            print("Duplicate number")
                            return
                        } else {
                            if contact.givenName.isEmpty || phone.isEmpty { //if the contact is missing data don't add to array of contacts
                                return
                            } else {
                                if let formattedPhone = phone.formatPhone() {
                                    let contact = SelectableContact(name: name, phoneNum: formattedPhone, userData: nil, selected: false)
                                    self.checkIfContactIsUser(contact: contact, callback: { (uid) in
                                        if let uid = uid {
                                            self.fetchCurrentUserData(uid: uid, completionHandler: { (userData) in
                                                if let userData = userData {
                                                    if formattedPhone != localStorage.currentUserData()!["phoneNumber"] {
                                                        let newuser = user(name: userData["name"]!, profileImageURL: userData["profileImageURL"]!, phoneNumber: userData["phoneNumber"]!, uid: userData["uid"]!)
                                                        contact.userData = newuser
                                                        userContacts.append(contact)
                                                        callback(userContacts)
                                                    }
                                                }
                                            })
                                        } else {
                                            userContacts.append(contact)
                                            callback(userContacts)
                                        }
                                    })
                                    phonesArray.append(phone)
                                }
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
    
    func checkIfContactIsUser(contact: SelectableContact, callback: @escaping ((_ uid:String?) ->Void ))  {
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
                    callback(nil)
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
    
    func getUID() -> String {
        let auth = Auth.auth()
        guard let uid = auth.currentUser?.uid else {
            fatalError("NO USER ID")
        }
        return uid
    }
    
    func fetchCurrentUserData(uid: String, completionHandler: @escaping (_ userData: Dictionary<String, String>?) -> ()) { //gets the users data from firestore and stores it in currentUser dictionary
        let docRef = db.collection("users").document(uid) //Retrieves document named with users id
        docRef.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    let data = snapshot.data() as! [String : String]
                    completionHandler(data)
                    //Perform element setup after fetching complete
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
}

extension NewPlanController: firebaseFunctions {}
extension ProfileImageInputController: firebaseFunctions {}
extension HomeController: firebaseFunctions {}
