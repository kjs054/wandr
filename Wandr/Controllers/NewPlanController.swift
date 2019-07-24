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
    
    //FIXME:- Add cells for recent contacts and groups
    let activeContactId = "activeContactId"
    let otherContactId = "otherContactId"
    
    //MARK:- Elements
    var refreshControl = UIRefreshControl()
    
    let activityView = activityIndicatorView(color: .white, labelText: "Getting Your Contacts")
    
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
    
    let navigationBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let previewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowColor = UIColor.black.cgColor
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
    
    //MARK:- Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white //needed to prevent opacity issues during vc presentation
        view.layer.opacity = 50.0
        setupNavigationBar()
        setupRefreshControl()
        setupContactsTable()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.addSubview(navigationBar)
        navigationBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
        navigationBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        let navigationTitle = UILabel()
        navigationTitle.text = "Send A Plan"
        navigationTitle.font = UIFont(name: "Avenir-Heavy", size: 17)
        navigationTitle.textColor = wandrBlue
        navigationBar.addSubview(navigationTitle)
        navigationTitle.translatesAutoresizingMaskIntoConstraints = false
        navigationTitle.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor, constant: -11).isActive = true
        navigationTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: contentMargin).isActive = true
        
        let navigationSubtitle = UILabel()
        navigationSubtitle.text = "Autobahn Indoor Speedway"
        navigationSubtitle.font = UIFont(name: "Avenir-Heavy", size: 17)
        navigationSubtitle.textColor = #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)
        navigationBar.addSubview(navigationSubtitle)
        navigationSubtitle.translatesAutoresizingMaskIntoConstraints = false
        navigationSubtitle.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor, constant: 11).isActive = true
        navigationSubtitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: contentMargin).isActive = true
        
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        navigationBar.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -20).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
//        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func setupActivityView() {
        view.addSubview(activityView)
        activityView.anchor(top: navigationBar.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    func setupSendButton() {
        previewView.addSubview(sendButton)
        sendButton.anchor(top: nil, bottom: view.bottomAnchor, leading: previewView.leadingAnchor, trailing: previewView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: -15, right: -15))
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.addTarget(self, action: #selector(setupNewChat), for: .touchUpInside)
    }
    
    func setupMembersView() {
        previewView.addSubview(selectedUsersCollection)
        selectedUsersCollection.anchor(top: previewView.topAnchor, bottom: nil, leading: previewView.leadingAnchor, trailing: previewView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
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
            self.tableContainer.anchor(top: self.navigationBar.bottomAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
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
                selectedUsersCollection.collectionView.reloadData()
            } else {
                contactsOnWandr[indexPath.row].selected = true
                selectedUsersCollection.users.append(contactsOnWandr[indexPath.row])
                setupPreviewView()
                selectedUsersCollection.collectionView.reloadData()
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
            let vc = PlanChatController()
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
