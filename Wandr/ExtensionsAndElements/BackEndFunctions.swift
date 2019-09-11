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
import FirebaseFunctions
import FirebaseStorage
import Contacts

protocol FirebaseProtocol {
    func uploadImage(reference: String, image: UIImage, complete:@escaping ()->())
    func downloadURL(reference: String, complete:@escaping (String)->())
    func addNewUserToDatabase(userData: [String: String],complete:@escaping ()->())
    func addMessageToChat(chatID: String, content: String, type: Type, complete: (() -> Void)?)
    func addChatToDatabase(chatData: Dictionary<String,Any>, complete:@escaping (_ chatID: String)->())
    func addMemberToChat(chatID: String, user: User)
    func fetchMostRecentMessage(chatID: String, chatMembers: [User], completed: @escaping (Message) -> ())
    func fetchUserData(uid: String, completionHandler: @escaping (_ userData: User?) -> ())
    func getContacts(callback: @escaping (_ contacts: [SelectableContact]) -> ())
    func changeChatName(chatID: String, name: String)
    func fetchChatMessages(chatData: PlanChat, messageCallback: @escaping ([Message], DocumentChangeType) -> ())
    func deleteMessageFromChat(chatID: String, messageID: String)
    func checkIfContactIsUser(contact: SelectableContact, callback: @escaping (_ user:User?) ->())
}

protocol Fetchable {
    static var apiBase: String { get }
}

struct BackEndFunctions: FirebaseProtocol {
    
    fileprivate let db = Firestore.firestore()
    
    lazy var functions = Functions.functions()

    fileprivate let localStorage = LocalStorage()
    
    fileprivate let storage = Storage.storage()
    
    fileprivate let auth = Auth.auth()
    
    func fetch<Model: Fetchable>(_: Model.Type, id: String, completion: @escaping (DocumentSnapshot) -> Void) {
        let docRef = db.collection(Model.apiBase).document(id)
        docRef.addSnapshotListener() { (changeSnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            if let change = changeSnapshot {
                completion(change)
            }
        }
    }
    
    func callFunction(longitude: CGFloat, lattitude: CGFloat, radius: CGFloat, type: String) {
        let url = URL(string: "https://us-central1-wandr-244417.cloudfunctions.net/fetchPlaces?long=\(longitude)&lat=\(lattitude)&radius=\(radius)&type=\(type)")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
        
    }
    
    func uploadImage(reference: String, image: UIImage, complete:@escaping ()->()) {
        let storageRef = storage.reference().child(reference)
        if let uploadData = image.jpeg(.lowest) {
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                if error != nil {
                    return
                }
                complete()
            }
        }
    }
    
    func downloadURL(reference: String, complete:@escaping (String)->()) {
        let storageRef = storage.reference().child(reference)
        storageRef.downloadURL(completion: { (url, error) in
            guard let downloadURL = url?.absoluteString else {
                print(error!)
                return
            }
            complete(downloadURL)
        })
    }
    
    func addNewUserToDatabase(userData: [String: String],complete:@escaping ()->()) {
        db.collection("users").document(getUserID()).setData(userData) { err in
            if let err = err {
                fatalError("\(err)")
            } else {
                guard let phoneNumber = userData["phoneNumber"] else {
                    print("Couldnt get phone number")
                    fatalError("No Phone Number")
                }
                self.db.collection("registeredPhones").document(phoneNumber).setData(["uid": self.getUserID()])
                print("Document Written Successfully")
                complete()
            }
        }
    }
    
    func getUserID() -> String {
        if let currentUser = auth.currentUser {
            return currentUser.uid
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(LoginController(), animated: true)
            return ""
        }
    }
    
    func addMessageToChat(chatID: String, content: String = "", type: Type, complete: (() -> Void)? = nil) {
        let chatRef = db.collection("chats").document(chatID)
        let messageRef = chatRef.collection("messages").document()
        messageRef.setData(["sender": localStorage.currentUserData()!.uid, "timestamp": FieldValue.serverTimestamp(), "content": content, "type": type.rawValue, "messageID": messageRef.documentID])
        chatRef.updateData(["mostRecentMessage": messageRef.documentID])
        if let complete = complete {
            complete()
        }
    }
    
    func addChatToDatabase(chatData: Dictionary<String,Any>, complete:@escaping (_ chatID: String)->()) {
        let chatDoc = db.collection("chats").document()
        let chatID = chatDoc.documentID
        let users = chatData["members"] as! [String]
        chatDoc.setData(chatData) { err in
            if let err = err {
                fatalError("\(err)")
            } else {
                chatDoc.setData(["chatID": chatID], merge: true)
                users.forEach({ (UID) in
                    self.db.collection("users").document(UID).updateData([
                        "activeChats": FieldValue.arrayUnion([chatID])
                        ])
                })
                self.addMessageToChat(chatID: chatID, content: "", type: .info(.created)) {
                    complete(chatID)
                }
            }
        }
    }
    
    func fetchUserChats(uid: String, complete: @escaping (_ activeChats: [PlanChat]?) -> Void) {
        fetch(User.self, id: uid) { (snapshot) in
            guard let chats = snapshot.get("activeChats") as? [String] else {complete(nil); return}
            if chats.isEmpty {
                 complete(nil)
            } else {
                var results = [PlanChat]()
                let group = DispatchGroup.init()
                chats.forEach({ (chatID) in
                    group.enter()
                    self.fetchChatData(chatID: chatID) { (chatData) in
                        if results.contains(where: {$0.chatID == chatData.chatID}) {
                            results.removeAll(where: {$0.chatID == chatData.chatID})
                        } else {
                            group.leave()
                        }
                        results.append(chatData)
                    }
                })
                group.notify(queue: .main) {
                    complete(results.sorted(by: {$0.mostRecentMessage.timestamp.dateValue().compare($1.mostRecentMessage.timestamp.dateValue()) == .orderedDescending}))
                }
            }
        }
    }
    
    func fetchChatData(chatID: String, complete: @escaping (_ chatData: PlanChat) -> ()) {
        fetch(PlanChat.self, id: chatID) { (snapshot) in
            let members = snapshot.get("members") as! [String]
            let name = snapshot.get("name") as! String
            let id = snapshot.get("chatID") as! String
            let created = snapshot.get("created") as! Timestamp
            var count = 0
            var formattedMembers = [User]()
            members.forEach({ (user) in
                self.fetchUserData(uid: user) { (user) in
                    count += 1
                    formattedMembers.append(user!)
                    if count == members.count {
                        self.fetchMostRecentMessage(chatID: chatID, chatMembers: formattedMembers) { (message) in
                            let chat = PlanChat(name: name, chatID: id, members: formattedMembers, created: created, mostRecentMessage: message)
                            complete(chat)
                        }
                    }
                }
            })
        }
    }
    
    func fetchMostRecentMessage(chatID: String, chatMembers: [User], completed: @escaping (Message) -> ()) {
        let chatRef = db.collection("chats").document(chatID).collection("messages").order(by: "timestamp", descending: true).limit(to: 1)
        chatRef.getDocuments { (documents, error) in
            if let error = error {
                print(error)
                return
            }
            documents?.documents.forEach({ (document) in
                    let data = document.data()
                    self.formatMessage(chatMembers: chatMembers, messageData: data) { (formattedMessage) in
                        completed(formattedMessage)
                    }
            })
        }
    }
    
    
    func fetchUserData(uid: String, completionHandler: @escaping (_ userData: User?) -> ()) { //gets the users data from firestore and stores it in currentUser dictionary
        if getUserID() == uid && localStorage.currentUserData() != nil {
            completionHandler(localStorage.currentUserData())
            return
        }
        if localStorage.loadRegisteredContacts() != nil && localStorage.loadRegisteredContacts()!.contains(where: {$0.uid == uid}) {
            let user = localStorage.loadRegisteredContacts()!.first(where: {$0.uid == uid})
            completionHandler(user)
            return
        }
        fetch(User.self, id: uid) { (snapshot) in
            if snapshot.exists {
                let name = snapshot.get("name") as! String
                let profileImageURL = snapshot.get("profileImageURL") as! String
                let uid = snapshot.get("uid") as! String
                let phoneNumber = snapshot.get("phoneNumber") as! String
                completionHandler(User(name: name, profileImageURL: profileImageURL, phoneNumber: phoneNumber, uid: uid))
                return
            } else {
                completionHandler(nil)
                return
            }
        }
    }
    
    
    func addMemberToChat(chatID: String, user: User) {
        let chatRef = db.collection("chats").document(chatID)
        chatRef.updateData(["members": FieldValue.arrayUnion([user.uid])])
        addMessageToChat(chatID: chatID, content: user.name, type: .info(.invitedMember), complete: {})
        let userRef = db.collection("users").document(user.uid)
        userRef.updateData(["activeChats": FieldValue.arrayUnion([chatID])])
    }
    
    func getContacts(callback: @escaping (_ contacts: [SelectableContact]) -> ()) {
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
                        if phonesArray.contains(phone) || contact.givenName.isEmpty || phone.isEmpty {
                            return
                        } else {
                            phonesArray.append(phone)
                            if let formattedPhone = phone.formatPhone() {
                                if formattedPhone == self.localStorage.currentUserData()?.phoneNumber {
                                    return
                                } else {
                                    let contact = SelectableContact(name: name, phoneNum: formattedPhone, userData: nil, selected: false)
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
    
    func checkIfContactIsUser(contact: SelectableContact, callback: @escaping (_ user:User?) ->())  {
        if localStorage.loadRegisteredContacts() != nil && localStorage.loadRegisteredContacts()!.contains(where: {$0.phoneNumber == contact.phoneNum}) {
            callback(localStorage.loadRegisteredContacts()!.first(where: {$0.phoneNumber == contact.phoneNum}))
            return
        }
        let ref = db.collection("registeredPhones").document(contact.phoneNum)
        ref.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    print("Document Read: \(ref.path)")
                    let uidForContact = snapshot.get("uid") as! String
                    let contactData = ["uid": uidForContact]
                    let ref = self.db.collection("users").document(self.getUserID()).collection("contacts").document(contact.phoneNum)
                    ref.getDocument(completion: { (snapshot, error) in
                        if let snapshot = snapshot {
                            if snapshot.exists == false {
                                ref.setData(contactData)
                            }
                            self.fetchUserData(uid: uidForContact) { (user) in
                                if let user = user {
                                    callback(user)
                                    return
                                }
                            }
                        }
                    })
                } else {
                    callback(nil)
                    return
                }
            }
        }
        
    }
    
    
    func fetchChatMessages(chatData: PlanChat, messageCallback: @escaping ([Message], DocumentChangeType) -> ()) {
        let query = db.collection("chats").document(chatData.chatID).collection("messages").limit(to: 50).order(by: "timestamp", descending: true)
        query.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            var results = [Message]()
            let group = DispatchGroup()
            var changeType: DocumentChangeType = .added
            querySnapshot!.documentChanges.forEach({ (change) in
                group.enter()
                if change.type == .added || change.type == .removed {
                    changeType = change.type
                    self.formatMessage(chatMembers: chatData.members, messageData: change.document.data()) { (formattedMessage) in
                        results.append(formattedMessage)
                        group.leave()
                    }
                }
            })
            group.notify(queue: .main) {
                messageCallback(results, changeType)
            }
        }
    }
    
    func formatMessage(chatMembers: [User], messageData: [String: Any], formatted: @escaping (Message) -> ()) {
        var messageData = messageData
        if chatMembers.contains(where: {$0.uid == messageData["sender"] as! String}) {
            messageData["sender"] = chatMembers.first(where: {$0.uid == messageData["sender"] as! String})
            formatted(Message(dictionary: messageData))
        } else {
            self.fetchUserData(uid: messageData["sender"] as! String) { (user) in
                messageData["sender"] = user
                formatted(Message(dictionary: messageData))
            }
        }
    }
    
    func deleteMessageFromChat(chatID: String, messageID: String) {
        db.collection("chats").document(chatID).collection("messages").document(messageID).delete()
    }
    
    func changeChatName(chatID: String, name: String) {
        db.collection("chats").document(chatID).updateData(["name": name])
        addMessageToChat(chatID: chatID, content: name, type: .info(.renamed))
    }
    
    func leaveChat(chatID: String) {
        db.collection("users").document(getUserID()).updateData(["activeChats": FieldValue.arrayRemove([chatID])])
        db.collection("chats").document(chatID).updateData(["members": FieldValue.arrayRemove([getUserID()])])
        addMessageToChat(chatID: chatID, type: .info(.memberLeft))
    }
}