//
//  contactsTableViewTableViewController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/15/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

protocol contactDelegate: class {
    func handleSelectOfUser(selectedContact: SelectableContact)
}

class contactsTableView: UITableView, UITableViewDelegate {
    
    let activeContactId = "activeContact"
    let otherContactId = "otherContact"
    let planChatId = "planChat"
    
    var userContacts = [SelectableContact]()
    var contactsOnWandr = [SelectableContact]()
    var planChats = [PlanChat]()
    var membersInChat: [String]?
    
    var datasource:SectionedTableViewDataSource?
    
    weak var selectionDelegate: contactDelegate?
    
    convenience init?(membersInChat: [String]){
        self.init(frame: .zero, style: .plain)
        self.membersInChat = membersInChat
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        allowsSelection = true
        delegate = self
        separatorStyle = .none
        layer.cornerRadius = 30.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:  self.selectionDelegate!.handleSelectOfUser(selectedContact: contactsOnWandr[indexPath.item])
        case 2:  break
        default: break
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && planChats.isEmpty {
            return 0
        }
        return tableView.sectionHeaderHeight
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
        label.textColor = UIColor.mainBlue
        
        switch section {
        case 0: label.text = "Plans"
        case 1: label.text = "On Wandr"
        case 2: label.text = "All Contacts"
        default: break
        }
        return headerView
    }
    
    func getTableData(complete: @escaping ()->()) {
        let localStorage = LocalStorage()
        if let savedRegisteredUsers = localStorage.loadRegisteredContacts() {
            contactsOnWandr = savedRegisteredUsers.map({$0.toSelectableContact()})
        }
        BackEndFunctions().getContacts { (contacts) in
            self.userContacts = contacts
            self.userContacts.forEach({ (contact) in
                if contact.userData != nil {
                    if self.contactsOnWandr.contains(where: {$0.phoneNum == contact.phoneNum}) {
                        self.userContacts.removeAll(where: {$0.phoneNum == contact.phoneNum})
                    } else {
                        self.contactsOnWandr.append(contact)
                        localStorage.saveRegisteredContact(registeredContacts: self.contactsOnWandr.map({return $0.userData!}))
                        self.userContacts.removeAll(where: {$0.phoneNum == contact.phoneNum})
                    }
                }
            })
            if let membersInChat = self.membersInChat {
                self.contactsOnWandr = self.contactsOnWandr.filter{!membersInChat.contains($0.userData!.uid)}
            }
            self.register(activeContactCell.self, forCellReuseIdentifier: "contact")
            self.register(planPreviewCell.self, forCellReuseIdentifier: "planChat")
            self.register(activeContactCell.self, forCellReuseIdentifier: self.otherContactId)
            self.datasource = SectionedTableViewDataSource(dataSources: [
                TableViewDataSource.make(for: self.planChats),
                TableViewDataSource.make(for: self.contactsOnWandr),
                TableViewDataSource.make(for: self.userContacts)
                ])
            self.dataSource = self.datasource
            self.reloadData()
            complete()
        }
    }
}

class activeContactCell: UITableViewCell {
    
    var contact: SelectableContact! {
        didSet {
            contactCellView.subTitle.text = contact.phoneNum
            if contact.userData != nil {
                contactCellView.profileImage.setCachedImage(urlstring: contact.userData!.profileImageURL, size: contactCellView.profileImage.frame.size) {
                    self.contactCellView.setupProfileImage()
                }
                contactCellView.radioButton.isSelected = contact.selected ? true : false
                contactCellView.title.text = contact.userData!.name
                contactCellView.subTitle.text = contact.userData!.phoneNumber
                contactCellView.initialsLabel.removeFromSuperview()
                contactCellView.inviteButton.removeFromSuperview()
                contactCellView.setupRadioButton()
            } else {
                contactCellView.title.text = contact.name
                contactCellView.subTitle.text = contact.phoneNum
                contactCellView.initialsLabel.text = contact.name.getInitials()
                contactCellView.radioButton.removeFromSuperview()
                contactCellView.profileImage.removeFromSuperview()
                contactCellView.setupInitialsLabel()
                contactCellView.setupInviteButton()
            }
        }
    }
    
    let contactCellView = ContactView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contactCellView)
        contactCellView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
