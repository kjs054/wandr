//
//  NewPlanController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/12/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewPlanController: UIViewController {
    
    //MARK:- Elements
    
    var refreshControl = UIRefreshControl()
    
    let activityView = activityIndicatorView(color: .white, labelText: "")
    
    let tableContainer: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        return view
    }()
    
    let contactsTable = contactsTableView()
    
    fileprivate let planPlace: CardViewModel!
    
    lazy var sendPlanTitleBar = SendPlanTitleBar(planTitle: planPlace.headerText)
    
    let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        return view
    }()
    
    let selectedUsersCollection = selectedUsersCollectionView()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 25
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle("Send", for: .normal)
        button.backgroundColor = UIColor.mainBlue
        return button
    }()
    
    init(planPlace: CardViewModel) {
        self.planPlace = planPlace
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTable.selectionDelegate = self
        view.backgroundColor = .white //needed to prevent opacity issues during vc presentation
        view.layer.opacity = 50.0
        FirebaseFunctions().fetchUserChats(uid: FirebaseFunctions().getUserID()) { (chats)  in
            if let chats = chats {
                self.contactsTable.planChats = chats
            }
            self.setupContactsTable()
        }
        setupSendPlanTitleBar()
        setupRefreshControl()
        setupSwipeToExitGesture()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func setupSwipeToExitGesture() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownGesture))
        swipeDownGesture.direction = .down
        sendPlanTitleBar.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func handleSwipeDownGesture() {
        dismissViewController()
    }
    
    func setupSendPlanTitleBar() {
        sendPlanTitleBar.closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        self.navigationController?.navigationBar.isHidden = true
        self.view.addSubview(sendPlanTitleBar)
        sendPlanTitleBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
        sendPlanTitleBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupActivityView() {
        view.addSubview(activityView)
        activityView.anchor(top: sendPlanTitleBar.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    func setupSendButton() {
        previewView.addSubview(sendButton)
        sendButton.anchor(top: nil, bottom: view.bottomAnchor, leading: previewView.leadingAnchor, trailing: previewView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15))
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.addTarget(self, action: #selector(setupNewChat), for: .touchUpInside)
    }
    
    func setupMembersView() {
        previewView.addSubview(selectedUsersCollection)
        selectedUsersCollection.anchor(top: previewView.topAnchor, bottom: nil, leading: previewView.leadingAnchor, trailing: previewView.trailingAnchor)
        selectedUsersCollection.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        contactsTable.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func setupPreviewView() {
        view.addSubview(previewView)
        previewView.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        previewView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        setupSendButton()
        setupMembersView()
    }
    
    func setupContactsTable() {
        setupActivityView()
        contactsTable.getTableData {
            self.view.addSubview(self.tableContainer)
            self.view.bringSubviewToFront(self.previewView)
            self.tableContainer.anchor(top: self.sendPlanTitleBar.bottomAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
            self.tableContainer.addSubview(self.contactsTable)
            self.contactsTable.anchor(top: self.tableContainer.topAnchor, bottom: self.tableContainer.bottomAnchor, leading: self.tableContainer.leadingAnchor, trailing: self.tableContainer.trailingAnchor)
        }
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func setupNewChat() {
        sendButton.isEnabled = false
        var selectedContactsIds = selectedUsersCollection.users.compactMap({return $0.userData?.uid})
        selectedContactsIds.append(LocalStorage().currentUserData()!.uid)
        let chatData = ["name": "",
                        "members": selectedContactsIds,
                        "created": FieldValue.serverTimestamp()] as [String : Any]
        FirebaseFunctions().addChatToDatabase(chatData: chatData) { (chatID) in
            let vc = PlanChatController(chatID: chatID)
            let transition = CATransition().pushTransition(direction: .fromRight)
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK:- Logic
    func getInitials(_ name: String) -> String {
        let initials = String(name.first!)
        return initials
    }
    
    @objc func refresh(sender: AnyObject) {
        contactsTable.getTableData {
            self.refreshControl.endRefreshing()
        }
        selectedUsersCollection.users.removeAll()
        previewView.removeFromSuperview()
    }
}

extension NewPlanController: contactDelegate {
    
    func handleSelectOfUser(selectedContact: SelectableContact) {
        if selectedContact.selected { //checks to see if user is already selected
            selectedContact.selected = false
            selectedUsersCollection.users.removeAll(where: {$0.phoneNum == selectedContact.phoneNum})
            if selectedUsersCollection.users.isEmpty {
                previewView.removeFromSuperview()
            }
            selectedUsersCollection.reloadData()
        } else {
            selectedContact.selected = true
            selectedUsersCollection.users.append(selectedContact)
            setupPreviewView()
            selectedUsersCollection.reloadData()
        }
    }
}
