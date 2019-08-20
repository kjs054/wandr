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
    
    //MARK:- Variables
    fileprivate var chatID: String
    
    fileprivate let backend = FirebaseFunctions()
    
    fileprivate var hasFetchedMessages: Bool!
    
    fileprivate var hasAddedMembers: Bool!
    
    fileprivate var messages = [Message]()
    
    fileprivate var membersNamesToDisplay: [User]!
    
    fileprivate var chatData: PlanChat! {
        didSet {
            self.membersNamesToDisplay = self.chatData.members
            self.membersNamesToDisplay.removeAll(where: {$0.name == LocalStorage().currentUserData()?.name})
            if hasFetchedMessages == false {
                fetchMessages()
                hasFetchedMessages = true
            }
            if hasAddedMembers == false {
                membersCollection.members = chatData.members
                if chatData.name.isEmpty {
                    self.planChatName.setTitle(self.getNavigationBarTitle(), for: .normal)
                }
                self.planChatName.setTitle(self.getNavigationBarTitle(), for: .normal)
                hasAddedMembers = true
            } else {
                if chatData.members.count - 1 != membersCollection.members.count {
                    membersCollection.members = chatData.members
                    if chatData.name.isEmpty {
                        self.planChatName.setTitle(self.getNavigationBarTitle(), for: .normal)
                    }
                }
            }
            if chatData.name != planChatName.titleLabel?.text {
                self.planChatName.setTitle(self.getNavigationBarTitle(), for: .normal)
            }
        }
    }
    
    fileprivate let messageId = "message"
    
    fileprivate let infoId = "info"
    
    fileprivate var chatViewOffset: CGFloat = 0
    
    //MARK:- Elements
    let mainView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    let chatView = ChatView()
    
    let membersCollection = membersBubblesCollection()
    
    let planChatName: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let activityView = activityIndicatorView(color: .white, labelText: "Loading Chat Data")
    
    let createMessage = CreateMessageView()
    
    //MARK:- Controller Setup
    init(chatID: String) {
        self.chatID = chatID
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasAddedMembers = false
        hasFetchedMessages = false
        handleKeyboardLogic()
        setupActivityView()
        backend.fetchChatData(chatID: chatID) { (planChat) in
            self.chatData = planChat
            self.activityView.removeFromSuperview()
            self.setupMainView()
        }
        self.setupNavigationBar()
    }
    
    func setupActivityView() {
        view.addSubview(activityView)
        activityView.fillSuperView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        planChatName.addTarget(self, action: #selector(showChangeNameAlert), for: .touchUpInside)
        navigationItem.titleView = planChatName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainBlue, .font: UIFont(name: "Avenir-Heavy", size: 18)!]
        navigationController?.navigationBar.isTranslucent = false
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 2)
        backButton.imageView?.contentMode = .scaleAspectFit
        let moreInfoButton = UIButton()
        moreInfoButton.addTarget(self, action: #selector(showChatActionMenu), for: .touchUpInside)
        moreInfoButton.setImage(#imageLiteral(resourceName: "menuDots"), for: .normal)
        moreInfoButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 0)
        moreInfoButton.imageView?.contentMode = .scaleAspectFit
        navigationController?.navigationBar.layer.zPosition = 4
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreInfoButton)
    }
    
    fileprivate func handleKeyboardLogic() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.keyboardWillHide))
        gesture.direction = .down
        self.view.addGestureRecognizer(gesture)
        self.chatView.addGestureRecognizer(gesture)
        self.chatView.delegate = self
    }
    
    fileprivate func setupMainView() {
        view.addSubview(mainView)
        view.backgroundColor = .white
        let subviews = [membersCollection, chatView, createMessage]
        setupChatView()
        setupCreateMessageView()
        mainView.fillSuperView()
        subviews.forEach { (sv) in
            mainView.addArrangedSubview(sv)
            membersCollection.heightAnchor.constraint(equalToConstant: 50).isActive = true
            createMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        mainView.bringSubviewToFront(membersCollection)
    }
    
    fileprivate func setupChatView() {
        chatView.dataSource = self
        setupEndEditingGesture()
        chatView.delegate = self
        chatView.register(MessageCell.self, forCellWithReuseIdentifier: messageId)
        chatView.register(ChatInfoCell.self, forCellWithReuseIdentifier: infoId)
    }
    
    fileprivate func setupCreateMessageView() {
        createMessage.messageField.delegate = self
        createMessage.sendButton.addTarget(self, action: #selector(self.addMessage), for: .touchUpInside)
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        let transition = CATransition().pushTransition(direction: CATransitionSubtype.fromLeft)
        navigationController!.view.layer.add(transition, forKey: nil)
        for vc in navigationController?.viewControllers ?? [] {
            if vc is MyPlansController {
                navigationController?.popToViewController(vc, animated: false)
            }
        }
    }
    
    //MARK:- Logic
    @objc func addMessage() {
        if let messageText = createMessage.messageField.text {
            backend.addMessageToChat(chatID: chatData.chatID, content: messageText, type: .text) {
                self.createMessage.messageField.text = ""
                self.createMessage.sendButton.isEnabled = false
                print("Message added")
            }
        }
    }
    
    @objc func showChatActionMenu() {
        let chatActionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        chatActionMenu.addAction(UIAlertAction(title: "Add Member", style: .default, handler: { (_) in
            let vc = AddMemberToPlanController(chatData: self.chatData)
            let slideInTransitioningDelegate = SlideInPresentationManager()
            slideInTransitioningDelegate.direction = .bottom
            vc.transitioningDelegate = slideInTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }))
        chatActionMenu.addAction(UIAlertAction(title: "Change Group Name", style: .default, handler: { (_) in
            self.showChangeNameAlert()
        }))
        chatActionMenu.addAction(UIAlertAction(title: "Mute", style: .default, handler: { (_) in
            
        }))
        chatActionMenu.addAction(UIAlertAction(title: "Leave Plan", style: .destructive, handler: { (_) in
            let warningAlert = UIAlertController(title: "Are You Sure?", message: "You will not be able to access these plans unless re-invited.", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "I'm Sure", style: .destructive , handler: { (_) in
                self.backend.leaveChat(chatID: self.chatID)
            }))
            warningAlert.addAction(UIAlertAction(title: "Nevermind!", style: .default))
            self.present(warningAlert, animated: true)
        }))
        chatActionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(chatActionMenu, animated: true, completion: nil)
    }
    
    let bottomSafeArea = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.endEditing(true)
        createMessage.frame.origin.y = (view.safeAreaLayoutGuide.layoutFrame.height - createMessage.frame.height)
        chatView.frame.origin.y = (view.safeAreaLayoutGuide.layoutFrame.height - chatView.frame.height - createMessage.frame.height)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            chatView.frame.origin.y -= keyboardHeight - bottomSafeArea
            createMessage.frame.origin.y -= keyboardHeight - bottomSafeArea
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createMessage.messageField.resignFirstResponder()
        return true
    }
    
    func fetchMessages() {
        backend.fetchChatMessages(chatData: chatData) { (messages) in
            self.messages.insert(contentsOf: messages, at: 0)
            self.chatView.reloadData()
        }
    }
    
    fileprivate func getNavigationBarTitle() -> String {
        if chatData.name == "" {
            var otherUsersCount = ""
            if membersNamesToDisplay.count > 2 {
                let count = membersNamesToDisplay.count
                membersNamesToDisplay = Array(membersNamesToDisplay[0 ..< 2])
                otherUsersCount = "+\(count - membersNamesToDisplay.count) others"
            }
            return "\(membersNamesToDisplay.map({$0.name}).joined(separator: ", ")) \(otherUsersCount)"
        } else {
            return chatData.name
        }
    }
    
    @objc func showChangeNameAlert() {
        let changeNameAlert = UIAlertController(title: "Change Group Name", message: "Name changes will be seen by all of the group", preferredStyle: .alert)
        changeNameAlert.addTextField()
        changeNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        changeNameAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            if let newNameInput = changeNameAlert.textFields![0].text {
                self.backend.changeChatName(chatID: self.chatID, name: newNameInput)
                self.createMessage.messageField.resignFirstResponder()
            }
        }))
        self.present(changeNameAlert, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlanChatController: MessageDelegate {
    func showMessageActionMenu(message: Message) {
        createMessage.messageField.resignFirstResponder()
        let messageActionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        messageActionsMenu.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (_) in
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = message.content
        }))
        print(message.sender.uid)
        print(backend.getUserID())
        if message.sender.uid == backend.getUserID() {
            messageActionsMenu.addAction(UIAlertAction(title: "Unsend", style: .default, handler: { (_) in
                self.backend.deleteMessageFromChat(chatID: self.chatData.chatID, messageID: message.messageID)
            }))
        }
        messageActionsMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        navigationController?.present(messageActionsMenu, animated: true, completion: nil)
    }
}

extension PlanChatController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentMessage = messages[indexPath.item]
        switch currentMessage.type {
        case .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageId, for: indexPath) as! MessageCell
            cell.messageDelegate = self
            if checkIfNextMessageIsFromSameUser(indexPath) {
                cell.doesBreakTheSenderChain = false
            } else {
                cell.doesBreakTheSenderChain = true
            }
            cell.message = currentMessage
            return cell
        case .info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoId, for: indexPath) as! ChatInfoCell
            cell.message = currentMessage
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    fileprivate func checkIfNextMessageIsFromSameUser(_ indexPath: IndexPath) -> Bool {
        if indexPath.row != messages.count - 1 && messages[indexPath.row].sender.uid == messages[indexPath.row + 1].sender.uid && messages[indexPath.row + 1].type == .text {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch messages[indexPath.item].type {
        case .text:
            return CGSize(width: self.chatView.frame.width, height: 100)
        case .info:
            return CGSize(width: self.chatView.frame.width, height: 45)
        default:
            return CGSize(width: self.chatView.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: contentMargin, left: 0, bottom: 0, right: 0)
    }
}

extension PlanChatController: UIGestureRecognizerDelegate {
    func setupEndEditingGesture() {
        let endEditingGesture = UISwipeGestureRecognizer(target: self, action: #selector(textFieldShouldReturn(_:)))
        endEditingGesture.direction = .up
        chatView.addGestureRecognizer(endEditingGesture)
        endEditingGesture.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
