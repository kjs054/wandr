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
    
    fileprivate let backend = BackEndFunctions()
    
    fileprivate var hasFetchedMessages: Bool!
    
    fileprivate var hasAddedMembers: Bool!
    
    fileprivate var messages = [Message]()
    
    fileprivate var membersNamesToDisplay: [User]!
    
    fileprivate var chatData: PlanChat! {
        didSet {
            self.membersNamesToDisplay = self.chatData.members
            membersNamesToDisplay.removeAll(where: {$0.uid == BackEndFunctions().getUserID()})
            for (i, user) in self.membersNamesToDisplay.enumerated() {user.getUserColor(index: i)}
            if hasFetchedMessages == false {
                fetchMessages()
                hasFetchedMessages = true
            }
            if hasAddedMembers == false {
                self.titleView.members = chatData.members
                hasAddedMembers = true
            } else {
                if chatData.members.count - 1 != self.titleView.membersCollection.members.count {
                    self.titleView.members = chatData.members
                }
            }
            self.titleView.planName = self.getNavigationBarTitle()
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
    
    let titleView = PlanTitleView(frame: CGRect(x: 0, y: 0, width: 900, height: 35))
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    func setupActivityView() {
        view.addSubview(activityView)
        activityView.fillSuperView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
//        planChatName.addTarget(self, action: #selector(showChangeNameAlert), for: .touchUpInside)
        navigationController?.navigationBar.topItem?.titleView = titleView
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainBlue, .font: UIFont(name: "Avenir-Heavy", size: 18)!]
        navigationController?.navigationBar.isTranslucent = false
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        navigationController?.navigationBar.layer.zPosition = 4
        let showPlanInfoGesture = UITapGestureRecognizer(target: self, action: #selector(showChatMenu))
        titleView.addGestureRecognizer(showPlanInfoGesture)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.navigationBar.addShadow()
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
        let subviews = [chatView, createMessage]
        setupChatView()
        setupCreateMessageView()
        mainView.fillSuperView()
        subviews.forEach { (sv) in
            mainView.addArrangedSubview(sv)
            createMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
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
        if ((navigationController?.viewControllers.contains(where: {$0 is MyPlansController}))!) {
            navigationController?.popViewController(animated: false)
        } else {
            navigationController?.pushViewController(MyPlansController(), animated: false)
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
    
    @objc func showChatMenu() {
        self.createMessage.messageField.resignFirstResponder()
        let vc = PlanChatMenuController(chatData: self.chatData)
        let slideInTransitioningDelegate = SlideInPresentationManager()
        slideInTransitioningDelegate.direction = .bottom
        slideInTransitioningDelegate.height = UIScreen.main.bounds.height * 0.8
        vc.transitioningDelegate = slideInTransitioningDelegate
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
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
        backend.fetchChatMessages(chatData: chatData) { (messages, changeType) in
            if changeType == .added {
                self.messages.insert(contentsOf: messages, at: 0)
            }
            if changeType == .removed {
                self.messages.removeAll(where: {$0.messageID == messages[0].messageID})
            }
            self.chatView.reloadData()
        }
    }
    
    fileprivate func getNavigationBarTitle() -> String {
        if chatData.name == "" {
            var otherUsersCount = ""
            if membersNamesToDisplay.count == 0 {
                return "😥 You're All Alone"
            }
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
        case .text: return CGSize(width: self.chatView.frame.width, height: 100)
        case .info: return CGSize(width: self.chatView.frame.width, height: 45)
        default:    return CGSize(width: self.chatView.frame.width, height: 0)
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
