//
//  PlanChatController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/15/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PlanChatController: UIViewController, UITextFieldDelegate {
    
    //MARK:- Elements
    fileprivate var chatData: PlanChat
    
    let mainView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate lazy var titleBar = PlanChatTitleBar(chatTitle: chatData.name, chatMembers: chatData.members)
    
    let chatContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 4.0
        return view
    }()
    
    let chatView = ChatView()
    
    let createMessage = CreateMessageView()
    
    //MARK:- Controller Setup
    
    init(chat: PlanChat) {
        chatData = chat
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        fetchMessages()
        createMessage.messageField.delegate = self
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide))
        view.addGestureRecognizer(gesture)
    }
   
    fileprivate func setupMainView() {
        view.addSubview(mainView)
        let subviews = [titleBar, chatContainer, createMessage]
        titleBar.closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        chatContainer.addSubview(chatView)
        chatView.fillSuperView()
        mainView.fillSuperView()
        subviews.forEach { (sv) in
            mainView.addArrangedSubview(sv)
            titleBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
            createMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    //MARK:- Logic
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if createMessage.messageField == createMessage.messageField {
            createMessage.messageField.resignFirstResponder()
            if let messageText = textField.text {
                addMessageToChat(chatID: chatData.chatID, content: messageText) {
                    textField.text = ""
                    print("Message added")
                }
            }
            return false
        }
        return true
    }
    
    let bottomSafeArea = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.endEditing(true)
        createMessage.frame.origin.y = (view.frame.height - 94 - bottomSafeArea)
        chatContainer.frame.origin.y = (view.frame.height - chatContainer.frame.height - 94 - bottomSafeArea)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            chatContainer.frame.origin.y -= keyboardHeight - bottomSafeArea
            createMessage.frame.origin.y -= keyboardHeight - bottomSafeArea
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchMessages() {
        var messages = [Message]()
        let db = Firestore.firestore()
        let query = db.collection("chats").document(chatData.chatID).collection("messages").order(by: "timestamp")
        query.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    var data = change.document.data()
                    let user = self.chatData.members.first(where:{$0.uid == data["sender"] as! String})
                    data["sender"] = user
                    messages.append(Message(dictionary: data))
                    let reversedOrderMsgs = Array(messages.reversed())
                    self.chatView.messages = reversedOrderMsgs
                }
            })
            self.chatView.reloadData()
        }
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        let vc = MyPlansController()
        let transition = CATransition().pushTransition(direction: CATransitionSubtype.fromLeft)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
