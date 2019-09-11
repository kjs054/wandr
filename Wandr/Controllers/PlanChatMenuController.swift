//
//  PlanChatMenuController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/21/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class PlanChatMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var PlanNameCell = UITableViewCell()
    
    let tableView = UITableView()
    
    var MutePlanCell = UITableViewCell()
    
    let rowFont = UIFont(name: "Avenir-Heavy", size: 20)
    
    lazy var planNameTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = planChat.name
        textField.placeholder = "Type Name"
        textField.font = rowFont
        textField.textColor = UIColor.customGrey
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        leftLabel.text = "Plan Name:"
        leftLabel.font = rowFont
        leftLabel.textColor = UIColor.mainBlue
        textField.leftView = leftLabel
        textField.leftViewMode = .always
        return textField
    }()
    
    let muteControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = UIColor.mainBlue
        return switchControl
    }()
    
    var lastNameText: UITextField = UITextField()
    
    var planChat: PlanChat!
    
    let planChatMemberId = "planChatMember"
    
    init(chatData: PlanChat) {
        self.planChat = chatData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    fileprivate func setupMuteControlRow() {
        self.MutePlanCell.addSubview(muteControl)
        MutePlanCell.selectionStyle = .none
        muteControl.centerYAnchor.constraint(equalTo: MutePlanCell.centerYAnchor).isActive = true
        let muteLabel = UILabel()
        muteLabel.text = "Mute Plan:"
        muteLabel.font = rowFont
        muteLabel.textColor = UIColor.mainBlue
        MutePlanCell.addSubview(muteLabel)
        muteLabel.translatesAutoresizingMaskIntoConstraints = false
        muteLabel.leftAnchor.constraint(equalTo: MutePlanCell.leftAnchor, constant: contentMargin).isActive = true
        muteLabel.centerYAnchor.constraint(equalTo: MutePlanCell.centerYAnchor).isActive = true
        muteLabel.widthAnchor.constraint(equalToConstant: muteLabel.intrinsicContentSize.width).isActive = true
        muteControl.leftAnchor.constraint(equalTo: muteLabel.rightAnchor, constant:  contentMargin).isActive = true
        let leaveButton = UIButton()
        MutePlanCell.addSubview(leaveButton)
        leaveButton.setTitle("Leave", for: .normal)
        leaveButton.setTitleColor(UIColor.customRed, for: .normal)
        leaveButton.addTarget(self, action: #selector(showLeaveChatAlert), for: .touchUpInside)
        leaveButton.titleLabel?.font = rowFont
        leaveButton.translatesAutoresizingMaskIntoConstraints = false
        leaveButton.rightAnchor.constraint(equalTo: MutePlanCell.rightAnchor, constant: -contentMargin).isActive = true
        leaveButton.centerYAnchor.constraint(equalTo: MutePlanCell.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        tableView.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        tableView.delegate = self
        tableView.allowsSelection = false
        planNameTextField.delegate = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: planChatMemberId)
        tableView.dataSource = self
        self.PlanNameCell.addSubview(self.planNameTextField)
        planNameTextField.fillSuperView(padding: UIEdgeInsets(top: 0, left: contentMargin, bottom: 0, right: 0))
        setupMuteControlRow()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        planNameTextField.resignFirstResponder()
        if planNameTextField.text != planChat.name {
            BackEndFunctions().changeChatName(chatID: planChat.chatID, name: planNameTextField.text!)
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch(indexPath.row) {
            case 0: return self.PlanNameCell   // section 0, row 0 is the first name
            case 1: return self.MutePlanCell
            default: fatalError()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: planChatMemberId, for: indexPath) as! ChatUserCell
            cell.user = planChat.members[indexPath.item]
            return cell
        default: fatalError()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return planChat.members.count
        default: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let headerView = UIView()
            headerView.backgroundColor = .white
            let title = UILabel()
            title.font = rowFont
            title.textColor = UIColor.mainBlue
            headerView.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: contentMargin).isActive = true
            title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            let addMemberButton = UIButton()
            addMemberButton.translatesAutoresizingMaskIntoConstraints = false
            addMemberButton.addTarget(self, action: #selector(showAddMembersView), for: .touchUpInside)
            addMemberButton.setTitle("+ Add", for: .normal)
            addMemberButton.setTitleColor(UIColor.mainBlue, for: .normal)
            addMemberButton.titleLabel?.font = rowFont
            headerView.addSubview(addMemberButton)
            addMemberButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -contentMargin).isActive = true
            addMemberButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            title.text = "Members"
            return headerView
        default:
            return UIView()
        }
    }
    
    @objc func showLeaveChatAlert() {
        let warningAlert = UIAlertController(title: "Are You Sure?", message: "You will not be able to access these plans unless re-invited.", preferredStyle: .alert)
        let leaveAction = UIAlertAction(title: "I'm Sure", style: .default , handler: { (_) in
            BackEndFunctions().leaveChat(chatID: self.planChat.chatID)
            self.presentingViewController?.dismiss(animated: true)
        })
        warningAlert.addAction(leaveAction)
        warningAlert.preferredAction = leaveAction
        warningAlert.addAction(UIAlertAction(title: "Nevermind", style: .default))
        self.present(warningAlert, animated: true)
    }
    
    @objc func showAddMembersView() {
//        let vc = AddMemberToPlanController(chatData: self.planChat)
//        let slideInTransitioningDelegate = SlideInPresentationManager()
//        slideInTransitioningDelegate.height = UIScreen.main.bounds.height * 0.8
//        slideInTransitioningDelegate.direction = .bottom
//        vc.transitioningDelegate = slideInTransitioningDelegate
//        vc.modalPresentationStyle = .custom
//        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:  return contentMargin
        default: return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:  return 50
        case 1:  return 70
        default: return 0
        }
    }
    
}

class ChatUserCell: UITableViewCell {
    
    var user: User! {
        didSet {
            let isCurrentUser = user.uid == BackEndFunctions().getUserID()
            userView.leftColorIndicator.backgroundColor = isCurrentUser ? UIColor.mainBlue : user.displayColor
            userView.nameLabel.text = isCurrentUser ? "You" : user.name
            userView.profileImage.setCachedImage(urlstring: user.profileImageURL, size: CGSize(width: 30, height: 30), complete: {})
            userView.joinedLabel.text = user.phoneNumber
        }
    }
    
    let userView = ChatUserView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userView)
        userView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
