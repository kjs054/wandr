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
    func checkIfContactIsUser(contact: SelectableContact, callback: @escaping (_ user:User?) -> ())
    func fetchCurrentUserData(uid: String, completionHandler: @escaping (_ userData: User?) -> ())
    func getUID() -> String
}

extension firebaseFunctions {
    
    //MARK:- Registration Functions
    func uploadProfileImageToStorage(image: UIImage, complete:@escaping ()->()) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profileImages/\(getUID())")
        if let uploadData = image.jpeg(.lowest) {
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
    
    //MARK:- User Fetching Functions
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
                        let formattedPhone = phone.formatPhone()
                        let name = "\(contact.givenName) \(contact.familyName)" //combine first and last name
                        if formattedPhone == localStorage.currentUserData()!.phoneNumber || phonesArray.contains(phone) || contact.givenName.isEmpty || phone.isEmpty {
                            print("Issue with contact")
                            return
                        } else {
                            phonesArray.append(phone)
                            let contact = SelectableContact(name: name, phoneNum: formattedPhone!, userData: nil, selected: false)
                            self.checkIfContactIsUser(contact: contact, callback: { (userData) in
                                if let userData = userData { //If they exist
                                            contact.userData = userData
                                            userContacts.append(contact)
                                            callback(userContacts)
                                        
                                } else { //If not a user
                                    userContacts.append(contact)
                                    callback(userContacts)
                                }
                            })
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
    
    func checkIfContactIsUser(contact: SelectableContact, callback: @escaping (_ user:User?) ->())  {
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
                            self.fetchCurrentUserData(uid: uidForContact) { (user) in
                                if let user = user {
                                    callback(user)
                                }
                            }
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
    
    func fetchCurrentUserData(uid: String, completionHandler: @escaping (_ userData: Dictionary<String, Any>?) -> ()) { //gets the users data from firestore and stores it in currentUser dictionary
        let docRef = db.collection("users").document(uid) //Retrieves document named with users id
        docRef.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    let name = snapshot.get("name") as! String
                    let profileImageURL = snapshot.get("profileImageURL") as! String
                    let uid = snapshot.get("uid") as! String
                    let phoneNumber = snapshot.get("phoneNumber") as! String
                    var data = ["name": name, "profileImageURL": profileImageURL, "uid": uid, "phoneNumber": phoneNumber] as [String : Any]
                    if let chats = snapshot.get("activeChats") {
                        data["activeChats"] = chats
                    }
                    completionHandler(data)
                    //Perform element setup after fetching complete
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
    
    //MARK:- Chat backend logic
    
    func addChatDocument(chatData: Dictionary<String,Any>, complete:@escaping (_ chatID: String)->()) {
        let chatDoc = db.collection("chats").document()
        let chatID = chatDoc.documentID
        let users = chatData["members"] as! [String]
        chatDoc.setData(chatData) { err in
            if let err = err {
                fatalError("\(err)")
            } else {
                chatDoc.setData(["chatID": chatID], merge: true)
                print("Chat Data Written")
                users.forEach({ (UID) in
                    db.collection("users").document(UID).updateData([
                        "activeChats": FieldValue.arrayUnion([chatID])
                        ])
                })
                complete(chatID)
            }
        }
    }
    
    func fetchUserChats(uid: String, complete: @escaping (_ activeChats: [PlanChat]) -> ()) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (snapshot, error) in
            if let error = error {
                fatalError("\(error)")
            } else {
                if let chats = snapshot?.get("activeChats") as? [String] {
                    var count = 0
                    var allChats = [PlanChat]()
                    chats.forEach({ (chatID) in
                        self.fetchChatData(chatID: chatID) { (chatData) in
                            count += 1
                            allChats.append(chatData)
                            if count == chats.count {
                                complete(allChats)
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    func fetchChatData(chatID: String, complete: @escaping (_ chatData: PlanChat) -> ()) {
        let docRef = db.collection("chats").document(chatID)
        docRef.getDocument { (snapshot, error) in
            if error != nil {
                print("Couldn't get chat")
            }
            if let snapshot = snapshot {
                let members = snapshot.get("members") as! [String]
                let name = snapshot.get("name") as! String
                let id = snapshot.get("chatID") as! String
                let created = snapshot.get("created") as! Timestamp
                var count = 0
                var formattedMembers = [User]()
                members.forEach({ (user) in
                    self.fetchCurrentUserData(uid: user) { (user) in
                        count += 1
                        formattedMembers.append(user!)
                        if count == members.count {
                            let chat = PlanChat(name: name, chatID: id, members: formattedMembers, created: created)
                            complete(chat)
                        }
                    }
                })
            }
        }
    }
    
    func getMessageType(typeString: String) -> Type {
        switch typeString {
        case "text":
            return .text
        default:
            return .text
        }
    }
    
    func addMessageToChat(chatID: String, content: String, complete: @escaping () -> ()) {
        let docRef = db.collection("chats").document(chatID).collection("messages").document()
        docRef.setData(["sender": LocalStorage().currentUserData()!.uid, "timestamp": FieldValue.serverTimestamp(), "content": content, "type": "text"])
        complete()
    }
}


extension NewPlanController: firebaseFunctions {}
extension ProfileImageInputController: firebaseFunctions {}
extension HomeController: firebaseFunctions {}
extension PlanChatController: firebaseFunctions {}
extension membersBubblesCollection: firebaseFunctions {}
extension Message: firebaseFunctions {}
extension MyPlansController: firebaseFunctions {}
