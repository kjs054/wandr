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

class NewPlanController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Variables
    var userContacts = [SelectableContact]()
    var contactsOnWandr = [SelectableContact]()
    var selectedContacts = [SelectableContact]()
    
    let activeContactId = "activeContact"
    let otherContactId = "otherContact"
    
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
    
    let contactsTable: UITableView = {
        let table = UITableView()
        table.allowsSelection = true
        table.separatorStyle = .none
        table.layer.cornerRadius = 30.0
        table.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        table.layer.masksToBounds = true
        return table
    }()
    
    fileprivate let planPlace: CardViewModel
    
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
        button.backgroundColor = wandrBlue
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
        view.backgroundColor = .white //needed to prevent opacity issues during vc presentation
        view.layer.opacity = 50.0
        setupSendPlanTitleBar()
        setupRefreshControl()
        setupContactsTable()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
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
        contactsTable.delegate = self
        contactsTable.dataSource = self
        contactsTable.register(activeContactCell.self, forCellReuseIdentifier: activeContactId)
        contactsTable.register(otherContactCell.self, forCellReuseIdentifier: otherContactId)
        setupActivityView()
        getTableData {
            self.view.addSubview(self.tableContainer)
            self.view.bringSubviewToFront(self.previewView)
            self.tableContainer.anchor(top: self.sendPlanTitleBar.bottomAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
            self.tableContainer.addSubview(self.contactsTable)
            self.contactsTable.anchor(top: self.tableContainer.topAnchor, bottom: self.tableContainer.bottomAnchor, leading: self.tableContainer.leadingAnchor, trailing: self.tableContainer.trailingAnchor)
        }
    }
    
    //MARK:- Contacts Table Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if contactsOnWandr[indexPath.row].selected { //checks to see if user is already selected
                contactsOnWandr[indexPath.row].selected = false
                selectedUsersCollection.users.removeAll(where: {$0.phoneNum == contactsOnWandr[indexPath.row].phoneNum})
                if selectedUsersCollection.users.isEmpty {
                    previewView.removeFromSuperview()
                }
                selectedUsersCollection.reloadData()
            } else {
                contactsOnWandr[indexPath.row].selected = true
                selectedUsersCollection.users.append(contactsOnWandr[indexPath.row])
                setupPreviewView()
                selectedUsersCollection.reloadData()
            }
        }
        if indexPath.section == 1 {
            if userContacts[indexPath.row].selected { //checks to see if user is already selected
                userContacts[indexPath.row].selected = false
            } else {
                userContacts[indexPath.row].selected = true
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: activeContactId, for: indexPath) as! activeContactCell
            cell.contact = contactsOnWandr[indexPath.row]
            cell.selectionStyle = .none
            if cell.contact.selected {
                cell.contactCellView.radioButton.isSelected = true
            } else {
                cell.contactCellView.radioButton.isSelected = false
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: otherContactId, for: indexPath) as! otherContactCell
        cell.contact = userContacts[indexPath.row]
        cell.selectionStyle = .none
        if cell.contact.selected {
            cell.contactCellView.radioButton.isSelected = true
            //TODO:- Add to selected contacts array
        } else {
            cell.contactCellView.radioButton.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contactsOnWandr.count
        }
        return userContacts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headerView.backgroundColor = .white
        headerView.layer.opacity = 0.98
        let label = UILabel()
        headerView.addSubview(label)
        label.fillSuperView(padding: UIEdgeInsets(top: 0, left: contentMargin, bottom: 0, right: 0))
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        label.textColor = wandrBlue
        
        switch section {
        case 0:
            label.text = "On Wandr"
        case 1:
            label.text = "All Contacts"
        default:
            label.text = "All Contacts"
        }
        return headerView
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func setupNewChat() {
        var selectedContactsIds = selectedUsersCollection.users.compactMap({return $0.userData?.uid})
        selectedContactsIds.append(LocalStorage().currentUserData()!["uid"] as! String)
        let chatData = ["name": "default",
                        "users": selectedContactsIds,
                        "created": FieldValue.serverTimestamp()] as [String : Any]

        addChatDocument(chatData: chatData) {
            let vc = PlanChatController(chat: PlanChat(name: "The College Boys", members: [User(name: "Kevin Shiflett", profileImageURL: "https://firebasestorage.googleapis.com/v0/b/wandr-244417.appspot.com/o/profileImages%2FFBe0pDwPzGdVZFy88tgAroKWZm72?alt=media&token=f00f10de-5634-4c72-81f7-c6b17c36dd08", phoneNumber: "+1443944433", uid: "FBe0pDwPzGdVZFy88tgAroKWZm72"), User(name: "Jonah Willard", profileImageURL: "https://firebasestorage.googleapis.com/v0/b/wandr-244417.appspot.com/o/profileImages%2FNv93ePKaenP0hygUH7QGn2eqnGq1?alt=media&token=fcefd0a3-0ac0-4532-89e9-73fccc7fc8c8", phoneNumber: "+1443944433", uid: "dfsajkflasjfl")], messages: [Message(sender: User(name: "Kevin Shiflett", profileImageURL: "https://firebasestorage.googleapis.com/v0/b/wandr-244417.appspot.com/o/profileImages%2FFBe0pDwPzGdVZFy88tgAroKWZm72?alt=media&token=f00f10de-5634-4c72-81f7-c6b17c36dd08", phoneNumber: "+1443944433", uid: "FBe0pDwPzGdVZFy88tgAroKWZm72"), timestamp: Date(timeIntervalSinceReferenceDate: -123456789.0), content: "Ok Ill be tfsakdlfjsafsjfka;dfjl;dkfjaklfjsal;dfjsdfalhere", type: .text)], created:  Date(timeIntervalSinceReferenceDate: -123456789.0)))
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
        getTableData {
            self.refreshControl.endRefreshing()
        }
        selectedUsersCollection.users.removeAll()
        previewView.removeFromSuperview()
    }
    
    fileprivate func getTableData(complete: @escaping ()->()) {
        let localStorage = LocalStorage()
        if let savedRegisteredUsers = localStorage.loadRegisteredContacts() {
            contactsOnWandr = savedRegisteredUsers
        }
        getContacts { (contacts) in
            self.userContacts = contacts
            self.userContacts.forEach({ (contact) in
                if contact.userData != nil {
                    if self.contactsOnWandr.contains(where: {$0.phoneNum == contact.phoneNum}) {
                        self.userContacts.removeLast() //Removes the active user contact from the all contacts group, since its the latest to be appended
                    } else {
                        self.contactsOnWandr.append(contact)
                        localStorage.saveRegisteredContact(registeredContacts: self.contactsOnWandr)
                        self.userContacts.removeAll(where: {$0.phoneNum == contact.phoneNum})
                    }
                }
            })
            self.contactsTable.reloadData()
            complete()
        }
    }
}

class recentContactCell: UITableViewCell {
    
    let contactCellView = ContactView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contactCellView)
        contactCellView.setupRadioButton()
        contactCellView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class activeContactCell: UITableViewCell {
    
    var contact: SelectableContact! {
        didSet {
            contactCellView.subTitle.text = contact.phoneNum
            contactCellView.profileImage.loadImageWithCacheFromURLString(urlstring: contact.userData!.profileImageURL) {
                self.contactCellView.setupProfileImage()
            }
            contactCellView.title.text = contact.userData!.name
        }
    }
    
    let contactCellView = ContactView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contactCellView)
        contactCellView.setupRadioButton()
        contactCellView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class otherContactCell: UITableViewCell {
    
    var contact: SelectableContact! {
        didSet {
            contactCellView.title.text = contact.name
            contactCellView.subTitle.text = contact.phoneNum
            contactCellView.initialsLabel.text = contact.name.getInitials()
        }
    }
    
    let contactCellView = ContactView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contactCellView)
        contactCellView.setupInviteButton()
        contactCellView.setupInitialsLabel()
        contactCellView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
