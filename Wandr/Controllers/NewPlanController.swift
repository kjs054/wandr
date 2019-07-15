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
    
    //FIXME:- Add cells for recent contacts and groups
    let recentContactId = "recentContactId"
    let activeContactId = "activeContactId"
    let otherContactId = "otherContactId"
    
    //MARK:- Elements
    var refreshControl = UIRefreshControl()
    
    let contactsTable: UITableView = {
        let table = UITableView()
        table.allowsSelection = true
        table.separatorStyle = .none
        return table
    }()
    
    let createPlanButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle("Send", for: .normal)
        button.backgroundColor = wandrBlue
        button.layer.opacity = 0.5
        return button
    }()
    
    //MARK:- Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white //needed to prevent opacity issues during vc presentation
        setupNavigationBar()
        setupCreatePlanButton()
        setupRefreshControl()
        setupContactsTable()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Make A Plan"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.6588235294, blue: 1, alpha: 1), .font: UIFont(name: "NexaBold", size: 23)!]
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func setupCreatePlanButton() {
        view.addSubview(createPlanButton)
        createPlanButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: -15))
        createPlanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        contactsTable.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func setupContactsTable() {
        contactsTable.delegate = self
        contactsTable.dataSource = self
        contactsTable.register(activeContactCell.self, forCellReuseIdentifier: activeContactId)
        contactsTable.register(otherContactCell.self, forCellReuseIdentifier: otherContactId)
        getTableData {
            self.view.addSubview(self.contactsTable)
            self.contactsTable.anchor(top: self.view.topAnchor, bottom: self.createPlanButton.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: -15, right: 0))
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
            } else {
                contactsOnWandr[indexPath.row].selected = true
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
    
    var selectedIndexes = [Int]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: activeContactId, for: indexPath) as! activeContactCell
            cell.contact = contactsOnWandr[indexPath.row]
            cell.selectionStyle = .none
            if cell.contact.selected {
                cell.contactCellView.radioButton.isSelected = true
                //TODO:- Add to selected contacts array
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
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        label.layer.opacity = 0.98
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.textColor = wandrBlue
        label.backgroundColor = .white
        
        switch section {
        case 0:
            label.text = "On Wandr"
        case 1:
            label.text = "All Contacts"
        default:
            label.text = "All Contacts"
        }
        return label
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
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
            contactCellView.profileImage.loadImageWithCacheFromURLString(urlstring: contact.userData!.profileImageURL)
            contactCellView.title.text = contact.userData!.name
        }
    }
    
    let contactCellView = ContactView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contactCellView)
        contactCellView.setupProfileImage()
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
