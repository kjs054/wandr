//
//  NewPlanController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/12/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import Contacts

class NewPlanController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Variables
    var userContacts = [SelectableContact]()
    
    var selectedContacts = [SelectableContact]()
    
    //FIXME:- Add cells for recent contacts and groups
    //    let recentContactId = "recentContactId"
    //    let activeContactId = "activeContactId"
    let otherContactId = "otherContactId"
    
    //MARK:- Elements
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
    
    //MARK:- Contacts Logic
    private func fetchContacts() {
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
                        if contact.givenName.isEmpty || phone.isEmpty { //if the contact is missing data don't add to array of contacts
                            return
                        } else {
                            self.userContacts.append(SelectableContact(name: name, phoneNum: phone, selected: false))
                            DispatchQueue.main.async {
                                self.contactsTable.reloadData() //reloads the data on permission granted
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
    
    //MARK:- Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white //needed to prevent opacity issues during vc presentation
        setupNavigationBar()
        setupCreatePlanButton()
        setupContactsTable()
        fetchContacts()
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
    
    func setupContactsTable() {
        contactsTable.delegate = self
        contactsTable.dataSource = self
//        contactsTable.register(recentContactCell.self, forCellReuseIdentifier: recentContactId)
//        contactsTable.register(activeContactCell.self, forCellReuseIdentifier: activeContactId)
        contactsTable.register(otherContactCell.self, forCellReuseIdentifier: otherContactId)
        view.addSubview(contactsTable)
        contactsTable.anchor(top: view.topAnchor, bottom: createPlanButton.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: -15, right: 0))
    }
    
    //MARK:- Contacts Table Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userContacts[indexPath.row].selected { //checks to see if user is already selected
            userContacts[indexPath.row].selected = false
            
        } else {
            userContacts[indexPath.row].selected = true
        }
        tableView.reloadData()
    }

    var selectedIndexes = [Int]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: otherContactId, for: indexPath) as! otherContactCell
        let contactName = userContacts[indexPath.row].name
        let contactPhone = userContacts[indexPath.row].phoneNum
        cell.contactCellView.title.text = contactName
        cell.contactCellView.subTitle.text = contactPhone
        cell.contactCellView.initialsLabel.text = contactName.getInitials()
        cell.selectionStyle = .none
        if userContacts[indexPath.row].selected {
            cell.contactCellView.radioButton.isSelected = true
        } else {
            cell.contactCellView.radioButton.isSelected = false
        }
        return cell
    }
    
    func getInitials(_ name: String) -> String {
        let initials = String(name.first!)
        return initials
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            label.text = "My Contacts"
        case 1:
            label.text = "On Wandr"
        default:
            label.text = "All Contacts"
        }
        return label
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
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
