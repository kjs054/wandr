//
//  PlanChatController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/15/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class PlanChatController: UIViewController {
    
    //MARK:- Elements
    fileprivate var chatData: PlanChat
    
    let mainView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate lazy var titleBar = PlanChatTitleBar(chatTitle: chatData.name, chatMembers: chatData.members)
    
    let chatView: ChatView = {
        let chat = ChatView()
        chat.layer.shadowColor = UIColor.black.cgColor
        chat.layer.masksToBounds = true
        chat.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        chat.layer.shadowOpacity = 0.2
        chat.layer.shadowRadius = 4.0
        return chat
    }()
    
    fileprivate lazy var chatView = ChatView(messages: chatData.messages)
    
    let createMessage = CreateMessageView()
    
    //MARK:- Controller Setup
    
    init(chat: PlanChat) {
        chatData = chat
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide))
        view.addGestureRecognizer(gesture)
    }
    
    func setupTitleBar() {
        navigationController?.navigationBar.isHidden = true
        
    }
    
    fileprivate func setupMainView() {
        view.addSubview(mainView)
        let subviews = [titleBar, chatView, createMessage]
        mainView.fillSuperView()
        subviews.forEach { (sv) in
            mainView.addArrangedSubview(sv)
            titleBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
            createMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    //MARK:- Logic
    
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
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        let vc = MyPlansController()
        let transition = CATransition().pushTransition(direction: CATransitionSubtype.fromLeft)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
